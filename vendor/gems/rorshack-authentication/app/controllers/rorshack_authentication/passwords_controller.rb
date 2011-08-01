module RorshackAuthentication
  class PasswordsController < ApplicationController
    before_filter :make_password , :only => [:new , :show]
    def create
      @password = Password.new(params[:password])
      if @password.valid?
        #Thread.new do  # New thread results in not sending email ! Because heroku DONT allow to create new thread inside rails app
        @password.deliver_password_reset_notification!
        #end
        redirect_to iauth.password_path(0)
      else
        redirect_to iauth.login_path , :notice => t("email_not_existed")#"the email did not be used to signup."
      end
    end
    
    def edit
      @password = Password.new(:email => params[:email])
      logger.debug @password.inspect
      if @password.valid? && @password.account.perishable_token.eql?(params[:token])
        AccountSession.create(@password.account, true)
        @password.account.reset_perishable_token
        redirect_to iauth.edit_account_path(@password.account)
      end
    end
    def show;end
    def new;end

  private
    def make_password
      @password ||= Password.new
    end
  end
end
