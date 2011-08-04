module EventsHelper
  def get_current_points_of_event(event)
    ets = EventTrack.of_user(current_user.id).of_event(event.id)
    if ets.empty?
      0
    else
      ets.first.points
    end
  end
  
  def get_offer_code_of_event(event)
    EventTrack.of_user(current_user.id).of_event(event.id).winned.first.offer_code
  end
end
