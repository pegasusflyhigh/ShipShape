# frozen_string_literal: true

class CreateSailingOptionRates < ActiveRecord::Migration[7.0]

  def change
    create_table :sailing_option_rates do |t|
      t.references :sailing_option, null: false, foreign_key: true
      t.references :sailing_rate, null: false, foreign_key: true

      t.timestamps
    end
  end

end
