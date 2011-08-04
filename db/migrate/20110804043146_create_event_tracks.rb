class CreateEventTracks < ActiveRecord::Migration
  def change
    create_table :event_tracks do |t|
      t.belongs_to :user
      t.belongs_to :event
      t.integer    :points
      t.string     :offer_code
      t.datetime   :winned_at
      t.timestamps
    end
  end
end
