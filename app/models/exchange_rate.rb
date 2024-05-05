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
class ExchangeRate < ApplicationRecord
  validates :exchange_date, uniqueness: true, presence: true
  validates :jpy_rate, presence: true
  validates :usd_rate, presence: true
end
