# frozen_string_literal: true

# == Schema Information
#
# Table name: ports
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ports_on_code  (code) UNIQUE
#
FactoryBot.define do
  factory :port do
    code { Array.new(2) { Faker::Alphanumeric.unique.alpha(number: 3) }.join('-').upcase }
    name { Faker::Address.unique.city }
  end
end
