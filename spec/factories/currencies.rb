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
FactoryBot.define do
  factory :currency do
    code { Faker::Currency.unique.code }
    name { Faker::Currency.unique.name }
  end
end
