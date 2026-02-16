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

ActiveRecord::Schema[8.1].define(version: 2026_02_16_145729) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "price_points", force: :cascade do |t|
    t.decimal "average_price"
    t.string "brand"
    t.datetime "created_at", null: false
    t.decimal "max_price"
    t.decimal "min_price"
    t.string "platform"
    t.string "query"
    t.datetime "recorded_at"
    t.integer "result_count"
    t.datetime "updated_at", null: false
  end

  create_table "saved_searches", force: :cascade do |t|
    t.boolean "active"
    t.string "brand"
    t.string "category"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "last_checked_at"
    t.decimal "max_price"
    t.decimal "min_price"
    t.string "query"
    t.string "size"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_saved_searches_on_user_id"
  end

  create_table "search_results", force: :cascade do |t|
    t.string "condition"
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "external_id"
    t.string "image_url"
    t.datetime "listed_at"
    t.string "platform"
    t.decimal "price"
    t.bigint "saved_search_id", null: false
    t.string "seller"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["saved_search_id"], name: "index_search_results_on_saved_search_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "plan"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "saved_searches", "users"
  add_foreign_key "search_results", "saved_searches"
end
