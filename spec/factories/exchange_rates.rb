# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  exchange_date :date             not null
#  rate          :decimal(8, 2)    not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  currency_id   :bigint           not null
#
# Indexes
#
#  index_exchange_rates_on_currency_id                    (currency_id)
#  index_exchange_rates_on_exchange_date_and_currency_id  (exchange_date,currency_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#
FactoryBot.define do
  factory :exchange_rate do
    exchange_date { Faker::Date.unique.in_date_period }
    currency { association(:currency) }
    rate { 100.10 }
  end
end
