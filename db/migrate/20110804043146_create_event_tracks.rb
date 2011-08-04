class CreateEventTracks < ActiveRecord::Migration
  def change
    create_table :event_tracks do |t|
      t.belongs_to :invitor
      t.belongs_to :event
      t.integer    :points
      t.timestamps
    end
  end
end
