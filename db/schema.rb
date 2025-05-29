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

ActiveRecord::Schema[8.0].define(version: 2025_05_29_175446) do
  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "public", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "finance_id"
  end

  create_table "finances", force: :cascade do |t|
    t.integer "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_community", default: false
    t.string "name", default: "", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "community_id"
    t.boolean "is_community"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_payment_transactions_on_community_id"
    t.index ["user_id"], name: "index_payment_transactions_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payer_id"
    t.integer "receiver_id"
    t.integer "category"
    t.integer "status"
    t.integer "amount"
    t.integer "payment_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_communities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "community_id", null: false
    t.boolean "approved"
    t.integer "user_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_user_communities_on_community_id"
    t.index ["user_id"], name: "index_user_communities_on_user_id"
  end

  create_table "user_community_roles", force: :cascade do |t|
    t.string "name"
    t.integer "user_community_id", null: false
    t.integer "position"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_community_id"], name: "index_user_community_roles_on_user_community_id"
  end

  create_table "user_details", force: :cascade do |t|
    t.string "address"
    t.string "phone_number"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "532374683", null: false
    t.integer "finance_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "payment_transactions", "communities"
  add_foreign_key "payment_transactions", "users"
  add_foreign_key "payments", "payment_methods"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_communities", "communities"
  add_foreign_key "user_communities", "users"
  add_foreign_key "user_community_roles", "user_communities"
  add_foreign_key "user_details", "users"
end
