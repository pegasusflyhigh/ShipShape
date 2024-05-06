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
  has_many :sailing_option_rates, dependent: :nullify
  has_many :sailing_rates, through: :sailing_option_rates

  validates :arrival_date, presence: true
  validates :departure_date, presence: true

  scope :direct_between, lambda { |origin_port, destination_port|
    includes(:sailing_rates).where(origin_port:, destination_port:)
  }

end
