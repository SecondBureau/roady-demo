class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :make_message
  protected
  
  def default_url_options(options={})
    {:locale => "fr"}
  end
  
  def make_message
    @message = Message.new
  end
  
  def md5_key(*words)
    MD5.hexdigest(words.join('+++'))
  end
end
