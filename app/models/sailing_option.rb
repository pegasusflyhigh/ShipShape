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
class SailingOption < ApplicationRecord
  belongs_to :origin_port, class_name: 'Port'
  belongs_to :destination_port, class_name: 'Port'

  validates :arrival_date, presence: true
  validates :departure_date, presence: true
end
