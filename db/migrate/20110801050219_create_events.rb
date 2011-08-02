class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.string :locale , :default => "fr"
      t.string :title
      t.text :description
      t.text :content
      t.integer :discount
      t.integer :offer_count , :default => 0
      t.integer :offered_count , :default => 0
      t.timestamps
    end
  end
end
