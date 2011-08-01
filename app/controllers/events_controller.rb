class EventsController < ApplicationController
  
  def index
    @events = Event.of_locale_or_default.unexpired
  end
    
  def show
    @event = Event.of_locale_or_default.unexpired.where(:code => params[:code]).first
  end

end
