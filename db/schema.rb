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

ActiveRecord::Schema[7.0].define(version: 2023_04_30_200547) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "city"
    t.string "complement"
    t.string "country"
    t.string "neighborhood"
    t.integer "number"
    t.string "state"
    t.string "street"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movements", force: :cascade do |t|
    t.integer "amount"
    t.string "kind_cd"
    t.string "reason"
    t.date "expiration_date"
    t.date "occurrence_date"
    t.bigint "stock_id"
    t.bigint "supply_id"
    t.bigint "unit_id"
    t.bigint "created_by_id"
    t.string "source_type"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_movements_on_created_by_id"
    t.index ["source_type", "source_id"], name: "index_movements_on_source"
    t.index ["stock_id"], name: "index_movements_on_stock_id"
    t.index ["supply_id"], name: "index_movements_on_supply_id"
    t.index ["unit_id"], name: "index_movements_on_unit_id"
  end

  create_table "order_versions", force: :cascade do |t|
    t.string "aasm_state"
    t.string "reason"
    t.bigint "order_id"
    t.bigint "responsible_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_versions_on_order_id"
    t.index ["responsible_id"], name: "index_order_versions_on_responsible_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "amount"
    t.string "aasm_state"
    t.string "reason"
    t.bigint "stock_id"
    t.bigint "requesting_unit_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_orders_on_created_by_id"
    t.index ["requesting_unit_id"], name: "index_orders_on_requesting_unit_id"
    t.index ["stock_id"], name: "index_orders_on_stock_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "cns_number"
    t.string "nickname"
    t.string "document_number"
    t.string "cell_number"
    t.string "telephone_number"
    t.string "identity_document_type"
    t.string "identity_document_number"
    t.string "identity_document_issuing_agency"
    t.string "marital_status_cd"
    t.date "birth_date"
    t.string "owner_type"
    t.bigint "owner_id"
    t.bigint "address_id"
    t.bigint "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_people_on_address_id"
    t.index ["owner_type", "owner_id"], name: "index_people_on_owner"
    t.index ["unit_id"], name: "index_people_on_unit_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "identifier"
    t.date "arrived_date"
    t.date "expiration_date"
    t.integer "amount"
    t.integer "remaining"
    t.bigint "supply_id"
    t.bigint "unit_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_stocks_on_created_by_id"
    t.index ["supply_id"], name: "index_stocks_on_supply_id"
    t.index ["unit_id"], name: "index_stocks_on_unit_id"
  end

  create_table "supplies", force: :cascade do |t|
    t.string "name"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_supplies_on_created_by_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "email"
    t.string "cnes_number"
    t.string "kind_cd"
    t.boolean "active", default: true
    t.string "name"
    t.string "representative_name"
    t.string "representative_document_number"
    t.string "representative_cns_number"
    t.string "cell_number"
    t.string "telephone_number"
    t.string "identity_document_type"
    t.string "identity_document_number"
    t.string "identity_document_issuing_agency"
    t.date "birth_date"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.index ["address_id"], name: "index_units_on_address_id"
    t.index ["created_by_id"], name: "index_units_on_created_by_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "unit_id"
    t.string "kind_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_user_roles_on_unit_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.bigint "person_id"
    t.bigint "created_by_id"
    t.bigint "current_unit_id"
    t.index ["created_by_id"], name: "index_users_on_created_by_id"
    t.index ["current_unit_id"], name: "index_users_on_current_unit_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "movements", "stocks"
  add_foreign_key "movements", "supplies"
  add_foreign_key "movements", "units"
  add_foreign_key "movements", "users", column: "created_by_id"
  add_foreign_key "order_versions", "orders"
  add_foreign_key "order_versions", "users", column: "responsible_id"
  add_foreign_key "orders", "stocks"
  add_foreign_key "orders", "units", column: "requesting_unit_id"
  add_foreign_key "orders", "users", column: "created_by_id"
  add_foreign_key "people", "addresses"
  add_foreign_key "people", "units"
  add_foreign_key "stocks", "supplies"
  add_foreign_key "stocks", "units"
  add_foreign_key "stocks", "users", column: "created_by_id"
  add_foreign_key "supplies", "users", column: "created_by_id"
  add_foreign_key "units", "addresses"
  add_foreign_key "units", "users", column: "created_by_id"
  add_foreign_key "user_roles", "units"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "people"
  add_foreign_key "users", "units", column: "current_unit_id"
  add_foreign_key "users", "users", column: "created_by_id"
end
