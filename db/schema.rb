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

ActiveRecord::Schema.define(:version => 20110804043146) do

  create_table "event_tracks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "points"
    t.string   "offer_code"
    t.datetime "winned_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "code"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "locale",          :default => "fr"
    t.string   "title"
    t.text     "description"
    t.text     "content"
    t.integer  "discount"
    t.integer  "required_points"
    t.integer  "offer_count",     :default => 0
    t.integer  "offered_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_products", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "product_id"
  end

  create_table "images", :force => true do |t|
    t.integer  "image_owner_id"
    t.string   "image_owner_type"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "description"
    t.string   "locale",      :default => "fr"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.boolean  "is_default_role", :default => false, :null => false
    t.string   "permissions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rorshack_authentication_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "email",                                            :null => false
    t.string   "crypted_password",  :limit => 128, :default => "", :null => false
    t.string   "password_salt",                    :default => "", :null => false
    t.string   "persistence_token"
    t.string   "perishable_token",                 :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rorshack_authentication_accounts", ["email"], :name => "index_accounts_on_email", :unique => true

  create_table "rorshack_authentication_authentications", :force => true do |t|
    t.integer  "account_id"
    t.string   "provider"
    t.string   "access_token"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rorshack_authentication_authentications", ["account_id"], :name => "index_authentications_on_account_id"

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "locale",     :default => "fr"
    t.string   "tooltip"
    t.boolean  "admin_only", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name", "locale"], :name => "index_settings_on_name_and_locale", :unique => true

  create_table "users", :force => true do |t|
    t.string   "nickname"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "address"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country",    :default => "France"
    t.integer  "invitor_id"
    t.string   "uid"
    t.boolean  "is_opt_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  add_index "users", ["role_id"], :name => "index_users_on_role_id"

end
