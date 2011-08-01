module RorshackAuthentication
  class AccountsController < ApplicationController
    before_filter :find_account , :only => [:edit , :update]
    def new
      if signed_in?
        flash[:notice] = t("successfully_logged_in")
        redirect_to main_app.root_url and return
      else
        session[:return_to] = request.fullpath
        @account = Account.new
      end
      respond_to do |format|
        format.html {@remote = false; render}
        format.js   {@remote = true;}
      end
    end
    
    def create
      @account = Account.new(params[:account])
      if defined?(APP_CONFIG) && APP_CONFIG[:recaptcha] && !recaptcha_valid?
        @account.errors.add(:base , "Please input corect capcha!")
        render_new
      else
        if @account.save
          @current_account = @account
          @current_account_session = RorshackAuthentication::AccountSession.create(@account)
          flash[:notice] = t("successfully_logged_in")
          UserNotification.registration_notification(@account).deliver
          redirect_to iauth.edit_user_path( @account.user )
        else
          render_new
        end
      end
    end
    def edit
      @authentications = current_account.authentications if current_account
    end
    
    def update
      if defined?(APP_CONFIG) && APP_CONFIG[:recaptcha] && !recaptcha_valid?
        @account.errors.add(:base , "Please input corect capcha!")
        render :action => 'edit'
      else
        if @account.update_attributes(params[:account])
          flash[:notice] = t("account.updated")
          redirect_to main_app.root_url
        else
          render :action => 'edit'
        end
      end
    end
  protected
    def render_new
      respond_to do |format|
          format.html {@remote = false; render :action => 'new'}
          format.js {@remote = true; render :action => 'new'}
      end
    end
    def find_account
      @account = current_account
    end
    
  end
end
