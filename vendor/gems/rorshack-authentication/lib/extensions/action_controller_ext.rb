module RorshackAuthentication
  module ActionControllerExt

    def self.included(base)
      base.class_eval do
        helper_method :current_account, :signed_in? , :current_user
      end
    end
    #
    # Authentication
    #
    def current_account_session
      return @current_account_session if defined?(@current_account_session)
      @current_account_session = RorshackAuthentication::AccountSession.find
    end
      
    def current_account
      return @current_account if defined?(@current_account)
      @current_account = current_account_session && current_account_session.record
    end

    def current_user
      current_account &&
      @current_user ||= current_account.user
    end

    def login_required
      session[:return_to] = request.fullpath
      redirect_to login_path unless signed_in?
    end

    def signed_in?
      !!current_account and !!current_user and !current_user.is_of_role?("guests")
    end
    def validate_recapcha
      unless recaptcha_valid?
        flash[:notice] = "Please input corect capcha!"
        redirect_back_or_default main_app.root_url 
      end
    end
  end
end
ActionController::Base.send :include, RorshackAuthentication::ActionControllerExt

# recaptcha
ActionController::Base.send :include , Rack::Recaptcha::Helpers

