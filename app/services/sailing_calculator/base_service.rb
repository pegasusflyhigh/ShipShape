# frozen_string_literal: true

# This class implements Dijkstra's algorithm to find the cheapest sailing options between
# an origin and destination port. The algorithm works as follows:
#
# 1. Initialize costs for each port with infinity, except for the origin port (cost = 0).
# 2. Initialize a simple queue with the origin port.
# 3. Until the queue is empty:
#    a. Dequeue the port with the minimum cost.
#    b. Process sailing options from the dequeued port.
#    c. Update costs and parents if a shorter path is found.
# 4. After processing all ports, the shortest path and its total cost are determined.
#
# The process_sailing_options method considers sailing rates, backtracing costs,
# and exchange rates to calculate the total cost of reaching each port.
#
# The class also provides methods to format and return the fastest sailing paths.
# If no paths are found or the origin and destination ports are the same, it returns an error.

module SailingCalculator
  class BaseService

    INFINITY = Float::INFINITY
    BASE_CURRENCY = Currency::BASE_CURRENCY

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
      return error_response(I18n.t(:origin_and_destination_must_be_different)) if same_origin_and_destination?
      return error_response if no_sailing_options_present?

      total_cost, paths = find_cheapest_sailing

      total_cost.infinite? ? error_response : success_response(paths)
    end

    private

    attr_reader :origin_port_code, :destination_port_code
    attr_accessor :queue, :parents, :costs

    def same_origin_and_destination?
      origin_port_code == destination_port_code
    end

    def no_sailing_options_present?
      [origin_port, destination_port, sailing_options(origin_port)].any?(&:blank?)
    end

    def find_cheapest_sailing
      process_all_ports

      [costs[destination_port], build_paths(parents, destination_port)]
    end

    def process_all_ports
      until queue.empty?
        current_port = port_with_minimum_cost
        queue.delete(current_port)
        process_sailing_options(sailing_options(current_port), current_port)
      end
    end

    def process_sailing_options(options, current_port)
      options.each do |option|
        neighbor_port = option.destination_port
        sailing_rate = find_min_sailing_rate(option)
        total_cost = calculate_total_cost(option, sailing_rate, current_port)

        update_cost_and_parents(neighbor_port, current_port, option, sailing_rate, total_cost)
      end
    end

    def port_with_minimum_cost
      queue.min_by { |port| costs[port] }
    end

    def calculate_total_cost(option, sailing_rate, current_port)
      rate = calculate_rate(option, sailing_rate)
      backtraced_cost = cost_with_backtracing(current_port, option)
      rate.infinite? ? INFINITY : (costs[current_port] + rate + backtraced_cost)
    end

    def update_cost_and_parents(neighbor_port, current_port, option, sailing_rate, total_cost)
      return unless total_cost <= costs[neighbor_port]

      costs[neighbor_port] = total_cost
      parents[neighbor_port] = { port: current_port, option: option, sailing_rate: sailing_rate }
      add_to_queue(neighbor_port)
    end

    def add_to_queue(neighbor_port)
      queue << neighbor_port unless queue.include?(neighbor_port)
    end

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

    def find_min_sailing_rate(direct_sailing_option)
      direct_sailing_option.sailing_rates.min_by do |sailing_rate|
        calculate_rate(direct_sailing_option, sailing_rate)
      end
    end

    def calculate_rate(direct_sailing_option, sailing_rate)
      return sailing_rate.rate if sailing_rate.currency_code == BASE_CURRENCY

      exchange_rate = cached_exchange_rate(direct_sailing_option.departure_date, sailing_rate.currency_code)

      return INFINITY if exchange_rate.blank?

      sailing_rate.rate / exchange_rate
    end

    def cost_with_backtracing(current_port, option)
      return 0 unless parents.key?(current_port) && parents[current_port][:port] == destination_port

      backtraced_cost = 0
      starting_port = current_port
      starting_option = option

      loop do
        backtraced_cost += costs[starting_port]
        starting_option = parents[starting_port][:option]

        if parents[starting_port].blank?
          backtraced_cost = 0
          break
        end

        starting_port = parents[starting_port][:port]

        break if starting_port == origin_port || starting_port == current_port
      end

      backtraced_cost
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

    def sailing_options
      nil
    end

    def origin_port
      @origin_port ||= Port.find_by(code: origin_port_code)
    end

    def destination_port
      @destination_port ||= Port.find_by(code: destination_port_code)
    end

    def success_response(paths)
      result = format_sailing_options(paths)
      ServiceResponse.success(result)
    end

    def error_response(error_key = nil)
      ServiceResponse.error(error_key || I18n.t(:no_sailing_found, origin_port_code:, destination_port_code:))
    end

  end
end
