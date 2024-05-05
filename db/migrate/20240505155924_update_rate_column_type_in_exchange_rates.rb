# frozen_string_literal: true

class UpdateRateColumnTypeInExchangeRates < ActiveRecord::Migration[7.0]
  def self.up
    safety_assured do
      change_column :exchange_rates, :rate, :decimal, precision: 8, scale: 2
      remove_index :exchange_rates, name: 'index_exchange_rates_on_exchange_date'
      remove_index :exchange_rates, name: 'index_exchange_rates_on_currency_id_and_rate'
      add_index :exchange_rates, %i[exchange_date currency_id], unique: true
    end
  end

  def self.down
    safety_assured do
      change_column :exchange_rates, :rate, :integer
      add_index :exchange_rates, :exchange_date, unique: true
      remove_index :exchange_rates, %i[exchange_date currency_id], unique: true
      add_index :exchange_rates, %i[currency_id rate], unique: true
    end
  end
end
