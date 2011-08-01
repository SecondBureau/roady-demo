class EventsController < ApplicationController
  def index
    @events = Event.of_locale_or_default.unexpired
  end
end
