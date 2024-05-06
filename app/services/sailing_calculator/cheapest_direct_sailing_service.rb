# frozen_string_literal: true

module SailingCalculator
  class CheapestDirectSailingService < BaseService

    def call
      return ServiceResponse.error(I18n.t(:no_direct_sailing_found)) if no_sailing_options_present?

      calculate_cheaptest_option

      ServiceResponse.success(result)
    end

    private

    def no_sailing_options_present?
      [origin_port, destination_port, direct_sailing_options].any?(&:blank?)
    end

    def calculate_cheaptest_option
      min_rate = INFINITY

      direct_sailing_options.find_each do |direct_sailing_option|
        min_sailing_rate = find_min_sailing_rate(direct_sailing_option)

        next unless min_sailing_rate

        rate_value = calculate_rate(direct_sailing_option, min_sailing_rate)
        next unless rate_value < min_rate

        @min_direct_sailing_option = direct_sailing_option
        @min_sailing_rate = min_sailing_rate
        min_rate = rate_value
      end
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

    def direct_sailing_options
      @direct_sailing_options ||= SailingOption.includes(sailing_rates: :currency)
        .direct_between(origin_port, destination_port)
    end

  end
end
