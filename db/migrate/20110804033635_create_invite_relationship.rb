class CreateInviteRelationship < ActiveRecord::Migration
  def change
    create_table :event_bonus do|t|
      t.belongs_to :invitor
      t.belongs_to :event
      t.integer    :points
      t.string     :offer_code
    end
  end
end
