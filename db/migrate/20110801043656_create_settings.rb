class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string   "name"
      t.string   "value"
      t.string   "locale" , :default => "fr"
      t.string   "tooltip"
      t.boolean  "admin_only", :default => false, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "settings", ["name", "locale"], :name => "index_settings_on_name_and_locale", :unique => true
  end
end
