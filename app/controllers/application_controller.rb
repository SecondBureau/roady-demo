class ApplicationController < ActionController::Base
  protect_from_forgery
  protected
  
  def default_url_options(options={})
    {:locale => "fr"}
  end
  
  def md5_key(*words)
    MD5.hexdigest(words.join('+++'))
  end
end
