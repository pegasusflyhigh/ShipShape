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
class SailingRate < ApplicationRecord

  belongs_to :currency

  validates :sailing_code, presence: true
  validates :rate, presence: true
  validates :sailing_code, uniqueness: { scope: :currency_id }

  delegate :code, to: :currency, prefix: true

end
