# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_05_145500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.date "exchange_date"
    t.integer "usd_rate"
    t.integer "jpy_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exchange_date"], name: "index_exchange_rates_on_exchange_date", unique: true
  end

  create_table "ports", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_ports_on_code", unique: true
  end

  create_table "sailing_options", force: :cascade do |t|
    t.bigint "origin_port_id", null: false
    t.bigint "destination_port_id", null: false
    t.date "departure_date", null: false
    t.date "arrival_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_port_id"], name: "index_sailing_options_on_destination_port_id"
    t.index ["origin_port_id"], name: "index_sailing_options_on_origin_port_id"
  end

  add_foreign_key "sailing_options", "ports", column: "destination_port_id"
  add_foreign_key "sailing_options", "ports", column: "origin_port_id"
end
