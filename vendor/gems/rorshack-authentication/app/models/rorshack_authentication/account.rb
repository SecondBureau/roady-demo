module RorshackAuthentication
  class Account < ActiveRecord::Base
    attr_accessor :password_confirmation
    
    has_many :authentications, :dependent => :destroy
    
    after_create :make_user
    
    acts_as_authentic do|c|
      c.login_field = :email
    end

    # TODO configurable user model
    def self.user_model_name
      "User"
    end
    
    def self.user_model
      Object.const_get( self.user_model_name )
    end
    
    if user_model_name
      before_validation :clean_data
      belongs_to :user , :class_name => user_model_name
      def make_user
        self.create_user unless self.user
      end
    end
    
    def self.find_or_create_from_omniauth(omniauth)
      account = Account.find_by_email(omniauth['user_info']['email'].scan(/[a-zA-Z0-9_]/).to_s.downcase) ||
             Account.new(:email => omniauth['user_info']['email'].scan(/[a-zA-Z0-9_]/).to_s.downcase) 
      account.save(:validate => false) #create the user without performing validations. This is because most of the fields are not set.
      account.reset_persistence_token! #set persistence_token else sessions will not be created
      account
    end
      
    def has_authentication(provider)
      self.authentications.exists?(:provider => provider.to_s)
    end
    def get_authentication(provider)
      self.authentications.where(:provider => provider.to_s).first
    end
    
    
  private

    
    def clean_data
      self.email = self.email.downcase unless self.email.nil?
    end
  end
end
