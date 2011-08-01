module RorshackAuthentication
  class AccountSessionsController < ApplicationController
# TODO enable recapcha
#    before_filter :validate_recapcha , :only => [:create]
    def new
      if signed_in?
        flash[:notice] = t("successfully_logged_in")
        redirect_to main_app.root_url
      else
        session[:return_to] = request.fullpath
        @account_session = AccountSession.new
        #render :layout => 'login'
        respond_to do |format|
          format.html {@remote = false;}
          format.js  {@remote = true;}
        end
     end
    end
    
    def create
      @account_session = AccountSession.new(params[:rorshack_authentication_account_session])
      if @account_session.save
        flash[:notice] = t("successfully_logged_in")
        redirect_back_or_default main_app.root_url
      else
        @error = t('account_sessions.user_does_not_exist')
        @account_session.password = nil
        respond_to do |format|
          format.html {@remote = false; render :action => 'new'}
          format.js {@remote = true; render :action => 'new'}
        end
      end
    end
    
    def destroy
      @authentications = current_account.authentications
      @authentications.each(&:destroy)
      @account_session = AccountSession.find
      @account_session.destroy unless @account_session.nil?
      reset_session
      flash[:notice] = t("successfully_logged_out")
      redirect_to main_app.root_url
    end
  end
end
