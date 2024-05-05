# frozen_string_literal: true

# spec/models/service_response_spec.rb
require 'rails_helper'

RSpec.describe ServiceResponse do
  describe '#success?' do
    context 'when status is success' do
      it 'returns true' do
        response = described_class.success('Success')
        expect(response.success?).to be(true)
      end
    end

    context 'when status is error' do
      it 'returns false' do
        response = described_class.error('Error')
        expect(response.success?).to be(false)
      end
    end
  end

  describe '#failure?' do
    context 'when status is success' do
      it 'returns false' do
        response = described_class.success('Success')
        expect(response.failure?).to be(false)
      end
    end

    context 'when status is error' do
      it 'returns true' do
        response = described_class.error('Error')
        expect(response.failure?).to be(true)
      end
    end
  end

  describe '.success' do
    it 'creates a new ServiceResponse with success status' do
      response = described_class.success('Success')
      expect(response.success?).to be(true)
      expect(response.result).to eq('Success')
    end
  end

  describe '.error' do
    it 'creates a new ServiceResponse with error status' do
      response = described_class.error('Error')
      expect(response.failure?).to be(true)
      expect(response.errors).to eq('Error')
    end

    it 'creates a new ServiceResponse with error status and custom error message' do
      response = described_class.error(:not_found, message: 'Record not found')
      expect(response.failure?).to be(true)
      expect(response.errors.full_messages).to contain_exactly('Record not found')
    end
  end
end
