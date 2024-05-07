# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SailingCalculator::CheapestSailingService do
  include_context 'when sailing data exists' do
    let_it_be(:service) { described_class.new(origin_port.code, destination_port.code) }

    let(:result) do
      [
        {
          origin_port: origin_port.code,
          destination_port: barcelona_port.code,
          departure_date: another_sailing_option_from_shanghai.departure_date.to_s,
          arrival_date: another_sailing_option_from_shanghai.arrival_date.to_s,
          sailing_code: shanghai_sailing_rate.sailing_code,
          rate: shanghai_sailing_rate.rate,
          rate_currency: shanghai_sailing_rate.currency_code
        },
        {
          origin_port: barcelona_port.code,
          destination_port: destination_port.code,
          departure_date: sailing_option_from_barcelona.departure_date.to_s,
          arrival_date: sailing_option_from_barcelona.arrival_date.to_s,
          sailing_code: barcelona_sailing_rate.sailing_code,
          rate: barcelona_sailing_rate.rate,
          rate_currency: barcelona_sailing_rate.currency_code
        }
      ]
    end

    it 'calculates the cheapest option' do
      service_response = service.call

      expect(service_response).to be_success
      expect(service_response.result).to eq(result)
    end

    it_behaves_like '#invalid_ports_or_sailing_options'
  end
end
