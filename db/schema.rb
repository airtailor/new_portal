# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180126205033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "street", null: false
    t.string "street_two"
    t.string "number", null: false
    t.string "city", null: false
    t.string "zip_code", null: false
    t.string "state_province", null: false
    t.string "country", default: "United States", null: false
    t.string "country_code", default: "US", null: false
    t.string "floor"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_type"
    t.index ["city"], name: "index_addresses_on_city"
    t.index ["country", "state_province", "zip_code", "city", "street", "number", "floor", "unit"], name: "by_compound_location"
    t.index ["floor"], name: "index_addresses_on_floor"
    t.index ["number"], name: "index_addresses_on_number"
    t.index ["state_province"], name: "index_addresses_on_state_province"
    t.index ["street"], name: "index_addresses_on_street"
    t.index ["street_two"], name: "index_addresses_on_street_two"
    t.index ["unit"], name: "index_addresses_on_unit"
    t.index ["zip_code"], name: "index_addresses_on_zip_code"
  end

  create_table "alteration_items", id: false, force: :cascade do |t|
    t.integer "alteration_id"
    t.integer "item_id"
  end

  create_table "alterations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hq_store_id"
    t.index ["hq_store_id"], name: "index_companies_on_hq_store_id"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "customer_addresses", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id", "customer_id"], name: "index_customer_addresses_on_address_id_and_customer_id", unique: true
    t.index ["address_id"], name: "index_customer_addresses_on_address_id"
    t.index ["customer_id"], name: "index_customer_addresses_on_customer_id"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "shopify_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "country", null: false
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company"
    t.boolean "agrees_to_terms"
    t.boolean "agrees_to_01_10_2018", default: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["first_name", "last_name"], name: "index_customers_on_first_name_and_last_name"
    t.index ["phone"], name: "index_customers_on_phone", unique: true
  end

  create_table "item_types", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_type_id"
    t.text "notes", default: ""
    t.index ["order_id"], name: "index_items_on_order_id"
  end

  create_table "measurements", id: :serial, force: :cascade do |t|
    t.float "sleeve_length"
    t.float "chest_bust"
    t.float "upper_torso"
    t.float "waist"
    t.float "pant_length"
    t.float "hips"
    t.float "thigh"
    t.float "knee"
    t.float "calf"
    t.float "ankle"
    t.float "back_width"
    t.float "bicep"
    t.float "forearm"
    t.float "inseam"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "elbow"
    t.float "shoulder_to_waist"
    t.index ["customer_id"], name: "index_measurements_on_customer_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "source", null: false
    t.bigint "source_order_id"
    t.integer "customer_id", null: false
    t.string "type"
    t.boolean "fulfilled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "arrived", default: false
    t.boolean "late", default: false
    t.text "requester_notes"
    t.text "provider_notes"
    t.float "subtotal"
    t.float "total", null: false
    t.float "discount"
    t.integer "provider_id"
    t.integer "requester_id"
    t.datetime "due_date"
    t.datetime "arrival_date"
    t.datetime "fulfilled_date"
    t.float "weight"
    t.boolean "ship_to_store"
    t.boolean "dismissed", default: false
    t.boolean "customer_alerted", default: false
    t.boolean "customer_picked_up", default: false
    t.index ["provider_id"], name: "index_orders_on_provider_id"
    t.index ["requester_id"], name: "index_orders_on_requester_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "shipment_orders", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.integer "order_id"
    t.index ["order_id"], name: "index_shipment_orders_on_order_id"
    t.index ["shipment_id"], name: "index_shipment_orders_on_shipment_id"
  end

  create_table "shipments", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weight"
    t.string "shipping_label"
    t.string "tracking_number"
    t.string "delivery_type"
    t.string "source_type"
    t.integer "source_id"
    t.string "destination_type"
    t.integer "destination_id"
    t.string "postmates_delivery_id"
    t.string "status"
    t.index ["destination_type", "destination_id"], name: "index_shipments_on_destination_type_and_destination_id"
    t.index ["source_type", "source_id"], name: "index_shipments_on_source_type_and_source_id"
  end

  create_table "stores", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "primary_contact_id"
    t.string "phone"
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "name", null: false
    t.integer "address_id"
    t.integer "default_tailor_id"
    t.boolean "agrees_to_terms", default: false
    t.index ["address_id"], name: "index_stores_on_address_id"
    t.index ["company_id"], name: "index_stores_on_company_id"
    t.index ["default_tailor_id"], name: "index_stores_on_default_tailor_id", where: "((type)::text = 'Retailer'::text)"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  add_foreign_key "measurements", "customers"
  add_foreign_key "stores", "addresses"
  add_foreign_key "stores", "stores", column: "default_tailor_id"
  add_foreign_key "users", "stores"
end
