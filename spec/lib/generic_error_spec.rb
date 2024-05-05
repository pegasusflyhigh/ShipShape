# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenericError do
  describe '#initialize' do
    context 'when error is a symbol' do
      it 'adds error to base with options' do
        error = described_class.new(:some_error, message: 'Custom message')
        expect(error.errors.full_messages).to include('Custom message')
      end
    end

    context 'when error is a string' do
      it 'raises a new GenericError exception' do
        expect do
          raise described_class.new('Something went wrong')
        end.to raise_error(described_class, 'Something went wrong')
      end
    end
  end
end
