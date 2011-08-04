class EventTrack < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  def self.update_bonus!(user , event , points)
    et = find_or_create_by_user_and_event(user , event)
    et.increment!(:points , points)
    event.offer_user!(user , et) if event.required_points <= et.points
  end
  
end
