# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  exchange_date :date
#  jpy_rate      :integer
#  usd_rate      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_exchange_rates_on_exchange_date  (exchange_date) UNIQUE
#
require 'rails_helper'

RSpec.describe ExchangeRate do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:exchange_date) }
    it { is_expected.to validate_presence_of(:usd_rate) }
    it { is_expected.to validate_presence_of(:jpy_rate) }
  end
end
