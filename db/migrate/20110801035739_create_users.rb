class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   "nickname"
      t.string   "firstname"
      t.string   "lastname"
      t.string   "gender"
      t.date     "birthdate"
      t.string   "address"
      t.string   "zipcode"
      t.string   "city"
      t.string   "country",                            :default => "France"
      t.integer  :invitor_id
      t.string   :uid
      t.boolean  :is_opt_in
      t.timestamps
    end
  end
end
