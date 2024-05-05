# frozen_string_literal: true

module DataImport
  class Import
    def initialize(json_data)
      @json_data = json_data
    end

    def call
      service_response = validate_json_data
      return service_response if service_response.failure?

      import_data && ServiceResponse.success({})
    end

    private

    attr_reader :json_data

    def validate_json_data
      JsonValidator.new(json_data).call
    end

    def import_data
      import_sailing_rates
      import_exchange_rates
      import_sailing_options
    end

    def import_sailing_rates
      # Parse and create sailing rate records along with currency records
      sailing_rate_records = []

      json_data['rates'].each do |sailing_data|
        currency = find_or_create_currency(sailing_data['rate_currency'])

        sailing_rate_records << {
          currency_id: currency.id,
          sailing_code: sailing_data['sailing_code'],
          rate: sailing_data['rate']
        }
      end

      SailingRate.upsert_all(sailing_rate_records, unique_by: %i[currency_id sailing_code]) # rubocop: disable Rails/SkipsModelValidations:
    end

    def import_exchange_rates
      # Parse and create exchange rates records
      exchange_rates_records = []

      json_data['exchange_rates'].each do |exchange_date, rates|
        rates.each do |currency_code, rate|
          currency = find_or_create_currency(currency_code)

          exchange_rates_records << build_exchange_rate_record(exchange_date, currency.id, rate)
        end
      end

      ExchangeRate.upsert_all(exchange_rates_records, unique_by: %i[exchange_date currency_id]) # rubocop: disable Rails/SkipsModelValidations:
    end

    def import_sailing_options
      # Parse sailing option data along with ports

      json_data['sailings'].each do |sailing|
        origin_port = find_or_create_port(sailing['origin_port'])
        destination_port = find_or_create_port(sailing['destination_port'])
        sailing_option = find_or_create_sailing_option(origin_port, destination_port, sailing)
        create_sailing_option_rates(sailing['sailing_code'], sailing_option)
      end
    end

    def build_exchange_rate_record(exchange_date, currency_id, rate)
      {
        exchange_date:,
        currency_id:,
        rate:
      }
    end

    def find_or_create_sailing_option(origin_port, destination_port, sailing)
      SailingOption.find_or_create_by(
        origin_port_id: origin_port.id,
        destination_port_id: destination_port.id,
        departure_date: sailing['departure_date'],
        arrival_date: sailing['arrival_date']
      )
    end

    def create_sailing_option_rates(sailing_code, sailing_option)
      SailingRate.where(sailing_code:).find_each do |sailing_rate|
        SailingOptionRate.create(sailing_rate_id: sailing_rate.id, sailing_option_id: sailing_option.id)
      end
    end

    def find_or_create_port(port_code)
      Port.find_or_create_by(code: port_code, name: "#{port_code}-name")
    end

    def find_or_create_currency(currency_code)
      Currency.find_or_create_by(code: currency_code.upcase)
    end
  end
end
