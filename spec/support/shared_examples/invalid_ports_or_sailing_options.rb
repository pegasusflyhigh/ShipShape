# frozen_string_literal: true

RSpec.shared_examples '#invalid_ports_or_sailing_options' do
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

  context 'when origin and destination are same' do
    let_it_be(:service) { described_class.new('ESBCN', 'ESBCN') }

    it 'returns error' do
      service_response = service.call

      error_message = 'Origin and destination must be different!'
      expect(service_response).to be_failure
      expect(service_response.errors).to eq(error_message)
    end
  end

  context 'when no sailing options origin from the origin port' do
    before do
      allow(service).to receive(:sailing_options).with(origin_port).and_return(nil)
    end

    it 'returns an error message' do
      service_response = service.call

      error_message = "No sailing option present between #{origin_port.code} and #{destination_port.code} ports"
      expect(service_response).to be_failure
      expect(service_response.errors).to eq(error_message)
    end
  end

  context 'when no sailing options are present connecting the origin to destination' do
    let_it_be(:service) { described_class.new('ESBCN', 'CNSHA') }

    it 'returns an error message' do
      service_response = service.call

      error_message = 'No sailing option present between ESBCN and CNSHA ports'
      expect(service_response).to be_failure
      expect(service_response.errors).to eq(error_message)
    end
  end
end
