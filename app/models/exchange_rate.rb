# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  exchange_date :date             not null
#  rate          :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  currency_id   :bigint           not null
#
# Indexes
#
#  index_exchange_rates_on_currency_id           (currency_id)
#  index_exchange_rates_on_currency_id_and_rate  (currency_id,rate) UNIQUE
#  index_exchange_rates_on_exchange_date         (exchange_date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#
class ExchangeRate < ApplicationRecord
  belongs_to :currency

  validates :exchange_date, uniqueness: true, presence: true
	validates :rate, presence: true
end
