module RorshackAuthentication
  class AuthenticationsController < ApplicationController
    
      before_filter :login_require, :only => [:destroy]

      def create
        if signed_in?
          auth = current_account.authentications.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        else
          auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
          auth = Authentication.find_or_create_from_omniauth(omniauth) if auth.nil?
          AccountSession.create(auth.account, true) #account is present. Login the account with his social account
        end
        auth.access_token = omniauth["credentials"]["token"]
        auth.save if auth.changed?
        redirect_to main_app.root_url
      end

      def destroy
        @authentication = current_account.authentications.find(params[:id])
        @authentication.destroy
        flash[:notice] = "#{t('authentications.provider_successfully_destroyed', :provider => @authentication.provider)}."
        redirect_to main_app.root_url
      end
      
      def failure
        flash[:warning] = "#{t('authentications.invalid_credentials')}."
        redirect_to main_app.root_url
      end
      
  private

    def omniauth
      request.env['omniauth.auth'] || request.env['rack.auth']
    end
  end
end
