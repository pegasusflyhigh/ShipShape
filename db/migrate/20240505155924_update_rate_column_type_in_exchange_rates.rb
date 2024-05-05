# frozen_string_literal: true

class UpdateRateColumnTypeInExchangeRates < ActiveRecord::Migration[7.0]
  def self.up
    safety_assured do
      change_column :exchange_rates, :rate, :decimal, precision: 8
    end
  end

  def self.down
    safety_assured do
      change_column :exchange_rates, :rate, :integer
    end
  end
end
