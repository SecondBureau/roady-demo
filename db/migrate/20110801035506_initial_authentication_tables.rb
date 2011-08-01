class InitialAuthenticationTables < ActiveRecord::Migration
  def self.up
    create_table "rorshack_authentication_authentications" do |t|
      t.integer  "account_id"
      t.string   "provider"
      t.string   "access_token"
      t.string   "uid"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "rorshack_authentication_accounts" do |t|
      t.integer  "user_id"
      t.string   "email",                                                   :null => false
      t.string   "crypted_password",   :limit => 128, :default => "",       :null => false
      t.string   "password_salt",                     :default => "",       :null => false
      t.string   "persistence_token"
      t.string   "perishable_token",                  :default => "",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "rorshack_authentication_authentications", ["account_id"], :name => "index_authentications_on_account_id"
    add_index "rorshack_authentication_accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  end

  def self.down
    drop_table :rorshack_authentication_accounts
    drop_table :rorshack_authentication_authentications
  end
end
