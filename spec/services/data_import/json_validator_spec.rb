# frozen_string_literal: true

# spec/services/data_import/json_validator_spec.rb
require 'rails_helper'

RSpec.describe DataImport::JsonValidator do
  describe '#call' do
    let(:valid_json_data) do
      {
        'sailings' => [
          { 'origin_port' => 'A', 'destination_port' => 'B', 'departure_date' => '2024-05-01',
            'arrival_date' => '2024-05-10', 'sailing_code' => 'ABCD' }
        ],
        'rates' => [
          { 'sailing_code' => 'ABCD', 'rate' => '100.00', 'rate_currency' => 'USD' }
        ],
        'exchange_rates' => {
          '2024-05-01' => { 'USD' => 1.0 }
        }
      }
    end

    let(:invalid_json_data) do
      {
        'sailings' => [
          { 'origin_port' => 'A', 'destination_port' => 'B', 'departure_date' => '2024-05-01',
            'arrival_date' => '2024-05-10', 'sailing_code' => 'ABCD' }
        ],
        'rates' => [
          { 'sailing_code' => 'ABCD', 'rate' => '100.00', 'rate_currency' => 'USD' }
        ],
        'exchange_rates' => {
          'invalid-date' => { 'USD' => 1.0 }
        }
      }
    end

    context 'with valid JSON data' do
      it 'returns a success response' do
        service_response = described_class.new(valid_json_data).call
        expect(service_response).to be_success
      end
    end

    context 'with invalid JSON data' do
      it 'returns an error response' do
        service_response = described_class.new(invalid_json_data).call
        expect(service_response).to be_failure
      end
    end
  end
end
