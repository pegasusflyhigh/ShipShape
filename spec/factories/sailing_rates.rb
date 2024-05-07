# frozen_string_literal: true

# == Schema Information
#
# Table name: sailing_rates
#
#  id           :bigint           not null, primary key
#  rate         :decimal(, )      not null
#  sailing_code :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  currency_id  :bigint           not null
#
# Indexes
#
#  index_sailing_rates_on_currency_id                   (currency_id)
#  index_sailing_rates_on_currency_id_and_sailing_code  (currency_id,sailing_code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#
FactoryBot.define do
  factory :sailing_rate do
    rate { 100 }
    currency { association(:currency) }
    sailing_code { 'ABCD' }
  end

  trait :with_euro_currency do
    currency { association(:currency, :euro) }
  end

  trait :with_japanese_yen_currency do
    currency { association(:currency, :japanese_yen) }
  end

  trait :with_us_dollars_currency do
    currency { association(:currency, :us_dollars) }
  end
end
