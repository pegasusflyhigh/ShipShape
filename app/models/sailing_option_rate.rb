# frozen_string_literal: true

# == Schema Information
#
# Table name: sailing_option_rates
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sailing_option_id :bigint           not null
#  sailing_rate_id   :bigint           not null
#
# Indexes
#
#  index_sailing_option_rates_on_sailing_option_id  (sailing_option_id)
#  index_sailing_option_rates_on_sailing_rate_id    (sailing_rate_id)
#
# Foreign Keys
#
#  fk_rails_...  (sailing_option_id => sailing_options.id)
#  fk_rails_...  (sailing_rate_id => sailing_rates.id)
#
class SailingOptionRate < ApplicationRecord
  belongs_to :sailing_option
  belongs_to :sailing_rate
end
