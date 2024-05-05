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
FactoryBot.define do
  factory :exchange_rate do
    exchange_date { Faker::Date.unique.in_date_period }
    usd_rate { 100 }
    jpy_rate { 100 }
  end
end
