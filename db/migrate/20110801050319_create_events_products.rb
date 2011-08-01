class CreateEventsProducts < ActiveRecord::Migration
  def change
    create_table :events_products , :id => false do|t|
      t.belongs_to :event
      t.belongs_to :product
    end
  end
end
