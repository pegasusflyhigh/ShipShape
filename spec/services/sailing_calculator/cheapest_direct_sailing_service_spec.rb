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

    it_behaves_like '#valid_ports_and_sailing_options'
    it_behaves_like '#invalid_ports_or_sailing_options'
  end
end
