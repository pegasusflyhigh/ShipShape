# frozen_string_literal: true

class CreateSailingRates < ActiveRecord::Migration[7.0]
  def change
    create_table :sailing_rates do |t|
      t.decimal :rate, null: false
      t.references :currency, null: false, foreign_key: true
      t.string :sailing_code, null: false

      t.index %i[currency_id sailing_code], unique: true

      t.timestamps
    end
  end
end
