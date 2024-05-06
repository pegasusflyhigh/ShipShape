# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[7.0]

  def change
    create_table :currencies do |t|
      t.string :code, limit: 3, null: false, unique: true
      t.string :name

      t.index :code, unique: true

      t.timestamps
    end
  end

end
