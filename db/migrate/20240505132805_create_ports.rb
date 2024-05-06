# frozen_string_literal: true

class CreatePorts < ActiveRecord::Migration[7.0]

  def change
    create_table :ports do |t|
      t.string :code, unique: true, null: false
      t.string :name, null: false

      t.index :code, unique: true

      t.timestamps
    end
  end

end
