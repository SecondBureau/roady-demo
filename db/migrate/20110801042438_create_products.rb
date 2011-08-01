class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   "title"
      t.text     "content"
      t.text     "description"
      t.string   "locale" , :default => "fr"
      t.string   "code"
      t.timestamps
    end
  end
end
