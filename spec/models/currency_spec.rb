# frozen_string_literal: true

# == Schema Information
#
# Table name: currencies
#
#  id         :bigint           not null, primary key
#  code       :string(3)        not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_currencies_on_code  (code) UNIQUE
#
require 'rails_helper'

RSpec.describe Currency do
  subject(:currency) { build(:currency) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code) }
    it { is_expected.to validate_length_of(:code).is_at_most(3).is_at_least(3) }
  end

  describe '#associations' do
    it { is_expected.to have_many(:exchange_rates) }
  end
end
