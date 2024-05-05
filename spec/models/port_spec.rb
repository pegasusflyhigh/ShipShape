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
require 'rails_helper'

RSpec.describe Port do
  subject(:port) { build(:port) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
