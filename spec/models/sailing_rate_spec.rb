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
require 'rails_helper'

RSpec.describe SailingRate do
  subject(:sailing_rate) { build(:sailing_rate) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:sailing_code) }
    it { is_expected.to validate_presence_of(:rate) }
    it { is_expected.to validate_uniqueness_of(:sailing_code).scoped_to(:currency_id) }
  end

  describe '#associations' do
    it { is_expected.to belong_to(:currency) }
  end
end
