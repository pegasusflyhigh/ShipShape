# frozen_string_literal: true

class CreateSailingOptions < ActiveRecord::Migration[7.0]

  def change
    create_table :sailing_options do |t|
      t.references :origin_port, foreign_key: { to_table: :ports }, null: false
      t.references :destination_port, foreign_key: { to_table: :ports }, null: false
      t.date :departure_date, null: false
      t.date :arrival_date, null: false

      t.timestamps
    end
  end

end
