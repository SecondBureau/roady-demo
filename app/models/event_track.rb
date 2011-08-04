class EventTrack < ActiveRecord::Base
  default_scope lambda{ order("winned_at DESC") }
  belongs_to :user
  belongs_to :event
  scope :winned , lambda { where("offer_code IS NOT NULL")}
  scope :of_user , lambda {|uid| where(:user_id => uid)}
  scope :of_event , lambda {|eid| where(:event_id => eid)}
  
  def self.update_bonus!(user , event , points)
    et = find_or_create_by_user_id_and_event_id( user.id , event.id )
    et.increment!(:points , points)
    if event.required_points <= et.points && EventTrack.winned.of_user(user.id).of_event(event.id).empty?
      event.offer_user!(user , et)
      et.winned_at = Time.current
      et.save
    end
  end
  
end
