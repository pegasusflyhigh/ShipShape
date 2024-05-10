# frozen_string_literal: true

RSpec.shared_examples '#valid_ports_and_sailing_options' do
  it 'calculates the fastest option' do
    service_response = service.call

    expect(service_response).to be_success
    expect(service_response.result).to eq(result)
  end
end
