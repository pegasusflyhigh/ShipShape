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
class Port < ApplicationRecord
  validates :code, uniqueness: true, presence: true
  validates :name, presence: true
end
