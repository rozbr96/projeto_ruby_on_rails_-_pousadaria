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

ActiveRecord::Schema[7.1].define(version: 2023_11_07_183249) do
  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.integer "number"
    t.string "complement"
    t.string "neighbourhood", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "postal_code", null: false
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_addresses_on_inn_id"
  end

  create_table "custom_prices", force: :cascade do |t|
    t.integer "inn_room_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_room_id"], name: "index_custom_prices_on_inn_room_id"
  end

  create_table "inn_payment_methods", force: :cascade do |t|
    t.boolean "enabled", default: false
    t.integer "inn_id", null: false
    t.integer "payment_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id", "payment_method_id"], name: "index_inn_payment_methods_on_inn_id_and_payment_method_id", unique: true
    t.index ["inn_id"], name: "index_inn_payment_methods_on_inn_id"
    t.index ["payment_method_id"], name: "index_inn_payment_methods_on_payment_method_id"
  end

  create_table "inn_phone_numbers", force: :cascade do |t|
    t.integer "inn_id", null: false
    t.integer "phone_number_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id", "phone_number_id"], name: "index_inn_phone_numbers_on_inn_id_and_phone_number_id", unique: true
    t.index ["inn_id"], name: "index_inn_phone_numbers_on_inn_id"
    t.index ["phone_number_id"], name: "index_inn_phone_numbers_on_phone_number_id"
  end

  create_table "inn_rooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "dimension", null: false
    t.integer "price", null: false
    t.integer "maximum_number_of_guests", null: false
    t.integer "number_of_bathrooms", null: false
    t.integer "number_of_wardrobes", null: false
    t.boolean "has_balcony", default: false
    t.boolean "has_tv", default: false
    t.boolean "has_air_conditioning", default: false
    t.boolean "has_vault", default: false
    t.boolean "is_accessible_for_people_with_disabilities", default: false
    t.boolean "enabled", default: false
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_inn_rooms_on_inn_id"
  end

  create_table "innkeepers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_innkeepers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_innkeepers_on_reset_password_token", unique: true
  end

  create_table "inns", force: :cascade do |t|
    t.string "name", null: false
    t.string "corporate_name", null: false
    t.string "registration_number", null: false
    t.string "description", null: false
    t.boolean "pets_are_allowed", null: false
    t.string "usage_policies", null: false
    t.string "email", null: false
    t.boolean "enabled", null: false
    t.integer "innkeeper_id", null: false
    t.time "check_in", null: false
    t.time "check_out", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_inns_on_email", unique: true
    t.index ["innkeeper_id"], name: "index_inns_on_innkeeper_id"
    t.index ["registration_number"], name: "index_inns_on_registration_number", unique: true
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_payment_methods_on_name", unique: true
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "city_code", null: false
    t.string "number", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_code", "number"], name: "index_phone_numbers_on_city_code_and_number", unique: true
  end

  add_foreign_key "addresses", "inns"
  add_foreign_key "custom_prices", "inn_rooms"
  add_foreign_key "inn_payment_methods", "inns"
  add_foreign_key "inn_payment_methods", "payment_methods"
  add_foreign_key "inn_phone_numbers", "inns"
  add_foreign_key "inn_phone_numbers", "phone_numbers"
  add_foreign_key "inn_rooms", "inns"
  add_foreign_key "inns", "innkeepers"
end
