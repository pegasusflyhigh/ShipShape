# frozen_string_literal: true

module SailingCalculator
  class BaseService

    INFINITY = Float::INFINITY

    def initialize(origin_port_code, destination_port_code)
      @origin_port_code = origin_port_code
      @destination_port_code = destination_port_code
      @exchange_rate_cache = {}
      @costs = Hash.new(INFINITY)
      @costs[origin_port] = 0
      @parents = {}
      @queue = [origin_port]
    end

    def call
      if no_sailing_options_present?
        return ServiceResponse.error(I18n.t(:no_sailing_found, origin_port_code:,
                                                               destination_port_code:))
      end

      total_cost, paths = find_cheapest_sailing

      total_cost.infinite? ? error_response : success_response(paths)
    end

    private

    attr_reader :origin_port_code, :destination_port_code
    attr_accessor :queue, :parents, :costs

    def no_sailing_options_present?
      [origin_port, destination_port, sailing_options(origin_port)].any?(&:blank?)
    end

    # Methods related to finding cheapest sailing
    def find_cheapest_sailing
      until queue.empty?
        current_port = port_with_minimum_cost
        queue.delete(current_port)
        new_sailing_options = sailing_options(current_port)
        process_sailing_options(new_sailing_options, current_port)
      end

      [costs[destination_port], build_paths(parents, destination_port)]
    end

    def process_sailing_options(options, current_port)
      options.each do |option|
        neighbor_port = option.destination_port
        sailing_rate = find_min_sailing_rate(option)
        rate = calculate_rate(option, sailing_rate)
        total_cost = calculate_total_cost(rate, current_port)

        update_cost_and_parents(neighbor_port, current_port, option, sailing_rate, total_cost)
      end
    end

    def calculate_total_cost(rate, current_port)
      rate.infinite? ? INFINITY : (costs[current_port] + rate)
    end

    def update_cost_and_parents(neighbor_port, current_port, option, sailing_rate, total_cost)
      return unless total_cost < costs[neighbor_port]

      costs[neighbor_port] = total_cost
      parents[neighbor_port] = { port: current_port, option: option, sailing_rate: sailing_rate }
      add_to_queue(neighbor_port)
    end

    def add_to_queue(neighbor_port)
      queue << neighbor_port unless queue.include?(neighbor_port)
    end

    # Methods related to building paths
    def build_paths(parents, destination_port)
      paths = []

      current_port = destination_port
      while parents[current_port]
        break if already_visited?(current_port)

        current_path = build_current_path(current_port)
        add_port_to_visited_ports(current_path[0][:port])

        add_path_to_paths(current_path, paths)
        current_port = update_current_port(current_path)
      end

      paths
    end

    def build_current_path(current_port)
      current_path = []

      until current_port.nil?
        if parents[current_port]
          current_path.unshift({ port: current_port, option: parents[current_port][:option],
                                 sailing_rate: parents[current_port][:sailing_rate] })
          current_port = parents[current_port][:port]
        else
          current_port = nil
        end
      end

      current_path
    end

    def add_path_to_paths(current_path, paths)
      paths << current_path if current_path.present?
    end

    def update_current_port(current_path)
      current_path.present? ? current_path[0][:port] : nil
    end

    # Other utility methods
    def port_with_minimum_cost
      queue.min_by { |port| costs[port] }
    end

    def find_min_sailing_rate(direct_sailing_option)
      direct_sailing_option.sailing_rates.min_by do |sailing_rate|
        calculate_rate(direct_sailing_option, sailing_rate)
      end
    end

    def calculate_rate(direct_sailing_option, sailing_rate)
      return sailing_rate.rate if sailing_rate.currency_code == Currency::BASE_CURRENCY

      exchange_rate = cached_exchange_rate(direct_sailing_option.departure_date, sailing_rate.currency_code)

      return INFINITY if exchange_rate.blank?

      sailing_rate.rate / exchange_rate
    end

    def format_sailing_options(paths)
      paths.map { |path| format_path(path) }.flatten
    end

    def format_path(path)
      path.map { |step| format_step(step) }
    end

    def format_step(step)
      {
        origin_port: step[:option].origin_port.code,
        destination_port: step[:option].destination_port.code,
        departure_date: step[:option].departure_date.to_s,
        arrival_date: step[:option].arrival_date.to_s,
        sailing_code: step[:sailing_rate].sailing_code,
        rate: step[:sailing_rate].rate,
        rate_currency: step[:sailing_rate].currency.code
      }
    end

    def cached_exchange_rate(date, currency_code)
      @exchange_rate_cache[date] ||= {}

      unless @exchange_rate_cache[date].key?(currency_code)
        @exchange_rate_cache[date][currency_code] =
          ExchangeRate.rate_for_date_and_currency(date, currency_code)&.rate
      end

      @exchange_rate_cache[date][currency_code]
    end

    def origin_port
      @origin_port ||= Port.find_by(code: origin_port_code)
    end

    def destination_port
      @destination_port ||= Port.find_by(code: destination_port_code)
    end

    def sailing_options
      nil
    end

    def already_visited?(port)
      visited_ports.include?(port)
    end

    def add_port_to_visited_ports(port)
      return if visited_ports.include?(port)

      visited_ports.add(port)
    end

    def visited_ports
      @visited_ports ||= Set.new
    end

    def success_response(paths)
      result = format_sailing_options(paths)
      ServiceResponse.success(result)
    end

    def error_response
      ServiceResponse.error("No sailing options found between #{origin_port_code} and #{destination_port_code}")
    end

  end
end
