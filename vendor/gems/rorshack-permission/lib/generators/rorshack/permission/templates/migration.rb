class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string   "name"
      t.boolean  "is_default_role", :default => false, :null => false
      t.string   "permissions"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    user_model = Object.const_get(RorshackAuthentication::Account.user_model_name)
    add_column  user_model.table_name.to_sym, :role_id , :integer
    add_index user_model.table_name, ["role_id"], :name => "index_users_on_role_id"
  end

  def self.down
    user_model = Object.const_get(RorshackAuthentication::Account.user_model_name)
    remove_column user_model.table_name.to_sym , :role_id
    drop_table :roles
  end
end
