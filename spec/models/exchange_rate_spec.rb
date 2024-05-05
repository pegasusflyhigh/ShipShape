# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  exchange_date :date             not null
#  rate          :decimal(8, )
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  currency_id   :bigint           not null
#
# Indexes
#
#  index_exchange_rates_on_currency_id    (currency_id)
#  index_exchange_rates_on_exchange_date  (exchange_date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#
require 'rails_helper'

RSpec.describe ExchangeRate do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:exchange_date) }
    it { is_expected.to validate_presence_of(:rate) }
  end

  describe '#associations' do
    it { is_expected.to belong_to(:currency) }
  end
end
