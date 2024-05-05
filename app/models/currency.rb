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
class Currency < ApplicationRecord
  has_many :exchange_rates, dependent: :nullify

  validates :code, presence: true, uniqueness: true, length: { maximum: 3, minimum: 3 }
end
