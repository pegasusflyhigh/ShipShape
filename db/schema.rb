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

ActiveRecord::Schema[7.0].define(version: 2024_05_05_161911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "code", limit: 3, null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.date "exchange_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "currency_id", null: false
    t.decimal "rate", precision: 8
    t.index ["currency_id"], name: "index_exchange_rates_on_currency_id"
    t.index ["exchange_date"], name: "index_exchange_rates_on_exchange_date", unique: true
  end

  create_table "ports", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_ports_on_code", unique: true
  end

  create_table "sailing_option_rates", force: :cascade do |t|
    t.bigint "sailing_option_id", null: false
    t.bigint "sailing_rate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sailing_option_id"], name: "index_sailing_option_rates_on_sailing_option_id"
    t.index ["sailing_rate_id"], name: "index_sailing_option_rates_on_sailing_rate_id"
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

  create_table "sailing_rates", force: :cascade do |t|
    t.decimal "rate", null: false
    t.bigint "currency_id", null: false
    t.string "sailing_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id", "sailing_code"], name: "index_sailing_rates_on_currency_id_and_sailing_code", unique: true
    t.index ["currency_id"], name: "index_sailing_rates_on_currency_id"
  end

  add_foreign_key "exchange_rates", "currencies"
  add_foreign_key "sailing_option_rates", "sailing_options"
  add_foreign_key "sailing_option_rates", "sailing_rates"
  add_foreign_key "sailing_options", "ports", column: "destination_port_id"
  add_foreign_key "sailing_options", "ports", column: "origin_port_id"
  add_foreign_key "sailing_rates", "currencies"
end
