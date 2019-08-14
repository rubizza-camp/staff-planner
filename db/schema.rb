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

ActiveRecord::Schema.define(version: 2019_08_12_204147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.date "start_day", null: false
    t.string "position"
    t.boolean "is_enabled", default: true, null: false
    t.bigint "account_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_employees_on_account_id"
    t.index ["company_id"], name: "index_employees_on_company_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "start_period", null: false
    t.datetime "end_period", null: false
    t.string "reason"
    t.bigint "employee_id", null: false
    t.bigint "company_id"
    t.bigint "rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_events_on_company_id"
    t.index ["employee_id"], name: "index_events_on_employee_id"
    t.index ["rule_id"], name: "index_events_on_rule_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name", null: false
    t.date "date", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_holidays_on_company_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "name", null: false
    t.integer "company_id", null: false
    t.integer "allowance_days", null: false
    t.string "period", null: false
    t.boolean "is_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_rules_on_company_id"
  end

  create_table "working_days", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.integer "day_of_week", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_working_days_on_company_id"
  end

  add_foreign_key "employees", "accounts"
  add_foreign_key "employees", "companies"
  add_foreign_key "events", "companies"
  add_foreign_key "events", "employees"
  add_foreign_key "events", "rules"
  add_foreign_key "holidays", "companies"
  add_foreign_key "working_days", "companies"
end
