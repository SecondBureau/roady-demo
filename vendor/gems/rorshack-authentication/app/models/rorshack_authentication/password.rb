module RorshackAuthentication
  class Password < Rorshack::Support::TablelessModel
    attr_accessor :email , :password , :password_confirmation , :account
    validates :email,
              :presence => true,
              :format   => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
    
    validates_presence_of :account  , :header_message => "Custom message one", :message => "Aucun utilisateur enregistré avec cet E-mail."
   
    def account
      nil if email.blank?
      Account.find_by_email(email)
    end
    
    def deliver_password_reset_notification!
       self.account.reset_perishable_token! unless self.account.nil?
       UserNotification.password_reset_notification(self).deliver
    end
  end
end
