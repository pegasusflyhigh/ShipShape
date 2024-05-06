# frozen_string_literal: true

class UpdateExchangeRatesSchemaWithCurrency < ActiveRecord::Migration[7.0]

  def change
    safety_assured do
      change_table :exchange_rates, bulk: true do |t|
        t.remove :usd_rate, type: :integer
        t.remove :jpy_rate, type: :integer
        t.column :rate, :integer, null: false

        t.references :currency, foreign_key: true, null: false, on_delete: :nullify

        t.index %i[currency_id rate], unique: true
      end

      change_column_null :exchange_rates, :exchange_date, false
    end
  end

end
