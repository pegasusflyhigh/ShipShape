# frozen_string_literal: true

# JsonValidator is a class that validates the structure and data of a JSON object
# according to our specific requirements. We will update this validator as and when
# MapReduce team informs us about any structure change in the JSON file

module DataImport
  class JsonValidator
    def initialize(json_data)
      @json_data = json_data
      @errors = []
    end

    def call
      return false unless json_data.is_a?(Hash)

      validate_sailings
      validate_rates
      validate_exchange_rates

      return ServiceResponse.error(errors) if errors.present?

      ServiceResponse.success({})
    end

    private

    attr_reader :json_data
    attr_accessor :errors

    def validate_sailings
      errors << I18n.t(:invalid_sailing_json_data) unless json_data['sailings'].is_a?(Array) &&
                                                          json_data['sailings'].all? do |sailing|
                                                            valid_sailing?(sailing)
                                                          end
    end

    def validate_rates
      errors << I18n.t(:invalid_rates_json_data) unless json_data['rates'].is_a?(Array) &&
                                                        json_data['rates'].all? do |rate|
                                                          valid_rate?(rate)
                                                        end
    end

    def validate_exchange_rates
      errors << I18n.t(:invalid_exchange_rates_json_data) unless json_data['exchange_rates'].is_a?(Hash) &&
                                                                 @json_data['exchange_rates'].all? do |date, rates|
                                                                   valid_exchange_rate?(date, rates)
                                                                 end
    end

    def valid_sailing?(sailing)
      sailing.is_a?(Hash) &&
        sailing.key?('origin_port') &&
        sailing.key?('destination_port') &&
        sailing.key?('departure_date') &&
        sailing.key?('arrival_date') &&
        sailing.key?('sailing_code')
    end

    def valid_rate?(rate)
      rate.is_a?(Hash) &&
        rate.key?('sailing_code') &&
        rate.key?('rate') &&
        rate.key?('rate_currency')
    end

    def valid_exchange_rate?(date, rates)
      Date.parse(date)
    rescue StandardError
      false &&
        rates.is_a?(Hash)
    end
  end
end
