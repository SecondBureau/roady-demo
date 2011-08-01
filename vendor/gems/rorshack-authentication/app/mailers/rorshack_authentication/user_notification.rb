module RorshackAuthentication
  class UserNotification < ActionMailer::Base
    
    helper :mailers
    
    default :from =>  'set_me_in_settings@example.com'
    
    def password_reset_notification(password)
      @account = password.account
      @host = UserNotification.mailer_host
      @url = edit_password_url(0, :email => password.email, :host => UserNotification.mailer_host, :token => @account.perishable_token)
      mail(:to => @account.email, :subject => "Reset Password")  
    end
    
    def registration_notification(account)
      @account = account
      mail(:to => account.email, :subject => t("user_notifications.registration_notification_subject"))
    end
    
    
    def self.mailer_host
      $mailer_host ||= Rails.env.production? ? ('setme.in.settings') : (Rails.env.development? ? 'localhost:3000' : (APP_CONFIG.nil? ? "" : APP_CONFIG[:hostname]))
    end
    
  end
end
