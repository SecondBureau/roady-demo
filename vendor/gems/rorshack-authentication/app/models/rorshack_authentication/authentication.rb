module RorshackAuthentication
  class Authentication < ActiveRecord::Base
    belongs_to :account
    validates_presence_of :rorshack_authentication_account_id, :uid, :provider
    validates_uniqueness_of :uid, :scope => :provider
    
    def self.find_or_create_from_omniauth(omniauth, account=nil)
      account ||= Account.find_or_create_from_omniauth(omniauth)
      Authentication.create(:account => account.id, :uid => omniauth['uid'], :provider => omniauth['provider'])
    end
  end
end
