# frozen_string_literal: true

# == Schema Information
#
# Table name: sailing_options
#
#  id                  :bigint           not null, primary key
#  arrival_date        :date             not null
#  departure_date      :date             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  destination_port_id :bigint           not null
#  origin_port_id      :bigint           not null
#
# Indexes
#
#  index_sailing_options_on_destination_port_id  (destination_port_id)
#  index_sailing_options_on_origin_port_id       (origin_port_id)
#
# Foreign Keys
#
#  fk_rails_...  (destination_port_id => ports.id)
#  fk_rails_...  (origin_port_id => ports.id)
#
require 'rails_helper'

RSpec.describe SailingOption do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:arrival_date) }
    it { is_expected.to validate_presence_of(:departure_date) }
  end

  describe '#associations' do
    it { is_expected.to belong_to(:destination_port).class_name('Port') }
    it { is_expected.to belong_to(:origin_port).class_name('Port') }
  end
end
