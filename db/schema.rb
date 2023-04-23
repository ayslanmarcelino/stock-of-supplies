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

ActiveRecord::Schema[7.0].define(version: 2023_03_26_040755) do
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

  create_table "enterprises", force: :cascade do |t|
    t.string "email"
    t.string "document_number"
    t.boolean "active", default: true
    t.string "name"
    t.string "trade_name"
    t.date "opening_date"
    t.string "representative_name"
    t.string "representative_document_number"
    t.string "cell_number"
    t.string "telephone_number"
    t.string "identity_document_type"
    t.string "identity_document_number"
    t.string "identity_document_issuing_agency"
    t.date "birth_date"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_enterprises_on_address_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "trade_name"
    t.string "nickname"
    t.string "document_number"
    t.string "cell_number"
    t.string "telephone_number"
    t.string "identity_document_type"
    t.string "identity_document_number"
    t.string "identity_document_issuing_agency"
    t.string "marital_status_cd"
    t.string "kind_cd"
    t.date "birth_date"
    t.string "owner_type"
    t.bigint "owner_id"
    t.bigint "address_id"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_people_on_address_id"
    t.index ["enterprise_id"], name: "index_people_on_enterprise_id"
    t.index ["owner_type", "owner_id"], name: "index_people_on_owner"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "enterprise_id"
    t.string "kind_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_user_roles_on_enterprise_id"
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
    t.bigint "current_enterprise_id"
    t.index ["current_enterprise_id"], name: "index_users_on_current_enterprise_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enterprises", "addresses"
  add_foreign_key "people", "addresses"
  add_foreign_key "people", "enterprises"
  add_foreign_key "user_roles", "enterprises"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "enterprises", column: "current_enterprise_id"
  add_foreign_key "users", "people"
end
