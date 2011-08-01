class CreateImages < ActiveRecord::Migration
  def change
  create_table "images", :force => true do |t|
    t.integer  "image_owner_id"
    t.string   "image_owner_type"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end
  end
end
