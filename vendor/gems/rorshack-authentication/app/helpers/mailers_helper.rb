module MailersHelper
  
  def image_url(source)
    abs_path = image_path(source)
    unless abs_path =~ /^http/
      abs_path = "http://#{UserNotification.mailer_host}#{abs_path}"
    end
    abs_path
  end

end
