# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SailingCalculator::CheapestDirectSailingService do
  include_context 'when sailing data exists' do
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
          allow(service).to receive(:sailing_options).with(origin_port).and_return(nil)
        end

        it 'returns an error message' do
          service_response = service.call

          expect(service_response).to be_failure
          expect(service_response.errors).to eq('No sailing option present between these ports')
        end
      end

      context 'when sailing options are present' do
        it 'calculates the cheapest option' do
          service_response = service.call

          expect(service_response).to be_success
          expect(service_response.result).to eq(result)
        end
      end
    end
  end
end
