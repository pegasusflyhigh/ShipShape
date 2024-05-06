# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SailingCalculator::CheapestDirectSailingService do
  let_it_be(:origin_port) { create(:port, code: 'CNSHA') }
  let_it_be(:destination_port) { create(:port, code: 'NLRTM') }

  let_it_be(:min_direct_sailing_option) do
    create(:sailing_option, :with_sailing_rates, origin_port:, destination_port:)
  end
  let_it_be(:min_sailing_rate) { min_direct_sailing_option.sailing_rates.first }
  let_it_be(:lowest_exchange_rate) do
    create(:exchange_rate, exchange_date: min_direct_sailing_option.departure_date,
                           currency: min_sailing_rate.currency, rate: 1.0)
  end

  let_it_be(:another_direct_sailing_option) do
    create(:sailing_option, :with_sailing_rates, origin_port:, destination_port:)
  end
  let_it_be(:another_sailing_rate) { another_direct_sailing_option.sailing_rates.first }
  let_it_be(:another_exchange_rate) do
    create(:exchange_rate, exchange_date: another_direct_sailing_option.departure_date,
                           currency: another_sailing_rate.currency, rate: 0.9)
  end

  let_it_be(:service) { described_class.new(origin_port.code, destination_port.code) }

  let(:result) do
    {
      origin_port: origin_port.code,
      destination_port: destination_port.code,
      departure_date: min_direct_sailing_option.departure_date.to_s,
      arrival_date: min_direct_sailing_option.arrival_date.to_s,
      sailing_code: min_sailing_rate.sailing_code,
      rate: min_sailing_rate.rate,
      rate_currency: min_sailing_rate.currency_code
    }
  end

  describe '#call' do
    context 'when origin port does not exist' do
      let_it_be(:service) { described_class.new('DUMMY', destination_port.code) }

      it 'returns failure' do
        service_response = service.call

        expect(service_response).to be_failure
      end
    end

    context 'when destination port does not exist' do
      let_it_be(:service) { described_class.new(origin_port.code, 'DUMMY') }

      it 'returns failure' do
        service_response = service.call

        expect(service_response).to be_failure
      end
    end

    context 'when no sailing options are present' do
      before do
        allow(service).to receive(:no_sailing_options_present?).and_return(true)
      end

      it 'returns an error message' do
        service_response = service.call

        expect(service_response).to be_failure
        expect(service_response.errors).to eq('No direct sailing option present between these ports')
      end
    end

    context 'when sailing options are present' do
      before do
        allow(service).to receive(:no_sailing_options_present?).and_return(false)
      end

      it 'calculates the cheapest option' do
        service_response = service.call

        expect(service_response).to be_success
        expect(service_response.result).to eq(result)
      end
    end
  end
end
