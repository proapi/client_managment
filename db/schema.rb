# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120711054907) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "code"
    t.string   "city"
    t.integer  "client_id"
    t.string   "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "addresses", ["client_id"], :name => "index_addresses_on_client_id"

  create_table "addresses_companies", :id => false, :force => true do |t|
    t.integer "address_id"
    t.integer "company_id"
  end

  add_index "addresses_companies", ["address_id"], :name => "index_addresses_companies_on_address_id"
  add_index "addresses_companies", ["company_id"], :name => "index_addresses_companies_on_company_id"

  create_table "agents", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "bills", :force => true do |t|
    t.integer  "clearing_id"
    t.integer  "company_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.decimal  "commission_final"
    t.date     "commission_date"
    t.decimal  "exchange_rate"
    t.date     "maturity_date"
    t.date     "payment_date"
    t.string   "number"
    t.integer  "user_id"
    t.text     "comment"
  end

  add_index "bills", ["clearing_id"], :name => "index_bills_on_clearing_id"
  add_index "bills", ["company_id"], :name => "index_bills_on_company_id"
  add_index "bills", ["number"], :name => "index_bills_on_number"
  add_index "bills", ["user_id"], :name => "index_bills_on_user_id"

  create_table "clearings", :force => true do |t|
    t.integer  "client_id"
    t.integer  "country_id"
    t.string   "tax_number"
    t.string   "year"
    t.date     "application_date"
    t.string   "commission_percent"
    t.decimal  "commission_min"
    t.decimal  "commission_currency"
    t.decimal  "rebate_calc"
    t.date     "office_send_date"
    t.decimal  "rebate_final"
    t.date     "decision_date"
    t.text     "description"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
    t.integer  "agent_id"
  end

  add_index "clearings", ["agent_id"], :name => "index_clearings_on_agent_id"
  add_index "clearings", ["client_id"], :name => "index_clearings_on_client_id"
  add_index "clearings", ["country_id"], :name => "index_clearings_on_country_id"

  create_table "clients", :force => true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.date     "birthdate"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "email"
    t.string   "identifier"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.string   "middlename"
    t.integer  "married"
    t.date     "married_date"
    t.text     "married_data"
    t.text     "children_data"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "short"
    t.string   "tax_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "bill_number"
    t.string   "account_number"
    t.string   "bank_name"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "short"
    t.string   "currency"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "documents", ["country_id"], :name => "index_documents_on_country_id"

  create_table "messages", :force => true do |t|
    t.string   "source"
    t.string   "origin"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "clearing_id"
  end

  add_index "messages", ["clearing_id"], :name => "index_messages_on_clearing_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
