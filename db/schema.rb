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

ActiveRecord::Schema.define(version: 20170613040425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alteration_items", id: false, force: :cascade do |t|
    t.integer "alteration_id"
    t.integer "item_id"
  end

  create_table "alterations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "hq_store_id"
    t.index ["hq_store_id"], name: "index_companies_on_hq_store_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "shopify_id"
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.string   "phone",      null: false
    t.string   "street1",    null: false
    t.string   "street2",    null: false
    t.string   "city",       null: false
    t.string   "state",      null: false
    t.string   "country",    null: false
    t.string   "zip",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "type_id"
    t.index ["order_id"], name: "index_items_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "source",                          null: false
    t.integer  "source_order_id"
    t.integer  "customer_id",                     null: false
    t.string   "type"
    t.boolean  "fulfilled",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "arrived",         default: false
    t.boolean  "late",            default: false
    t.text     "requester_notes"
    t.text     "provider_notes"
    t.float    "subtotal",                        null: false
    t.float    "total",                           null: false
    t.float    "discount"
    t.integer  "provider_id"
    t.integer  "requester_id"
    t.datetime "due_date"
    t.datetime "arrival_date"
    t.datetime "fulfilled_date"
    t.index ["provider_id"], name: "index_orders_on_provider_id", using: :btree
    t.index ["requester_id"], name: "index_orders_on_requester_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "stores", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "primary_contact_id"
    t.string   "phone"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "type"
    t.string   "name",               null: false
    t.index ["company_id"], name: "index_stores_on_company_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

end
