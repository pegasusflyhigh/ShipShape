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
end
