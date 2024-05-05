# frozen_string_literal: true

class CreateExchangeRates < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.date :exchange_date, unique: true
      t.integer :usd_rate
      t.integer :jpy_rate

      t.index :exchange_date, unique: true

      t.timestamps
    end
  end
end
