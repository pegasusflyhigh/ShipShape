# frozen_string_literal: true

module SailingCalculator
  class BaseService

    INFINITY = Float::INFINITY

    def initialize(origin_port_code, destination_port_code)
      @origin_port_code = origin_port_code
      @destination_port_code = destination_port_code
      @exchange_rate_cache = {}
      @min_sailing_rate = nil
      @min_sailing_option = nil
    end

    private

    attr_reader :origin_port_code, :destination_port_code, :min_sailing_rate, :min_sailing_option

    def no_sailing_options_present?
      [origin_port, destination_port, sailing_options].any?(&:blank?)
		end

    def cached_exchange_rate(date, currency_code)
      @exchange_rate_cache[date] ||= {}

      unless @exchange_rate_cache[date].key?(currency_code)
        @exchange_rate_cache[date][currency_code] =
          ExchangeRate.rate_for_date_and_currency(date, currency_code)&.rate
      end

      @exchange_rate_cache[date][currency_code]
    end

    def result
      {
        origin_port: origin_port_code,
        destination_port: destination_port_code,
        departure_date: min_sailing_option.departure_date.to_s,
        arrival_date: min_sailing_option.arrival_date.to_s,
        sailing_code: min_sailing_rate.sailing_code,
        rate: min_sailing_rate.rate,
        rate_currency: min_sailing_rate.currency_code
      }
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

  end
end
