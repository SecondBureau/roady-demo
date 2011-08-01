module Rorshack
  module Support
    module ControllerExt
      def self.included(base)
        base.class_eval do
          helper_method :detect_url
        end
      end
      protected
      
        def redirect_back_or_default(default, options={})
          redirect_to((session[:return_to] || default), options)
          session[:return_to] = nil
        end

        def store_location
          session[:return_to] = request.fullpath unless [iauth.login_path , iauth.account_sessions_path , iauth.signup_path , iauth.signup_path].any?{|_| _.eql? request.fullpath}
          logger.debug "RETURN TO : #{session[:return_to]} || #{request.fullpath} __ #{iauth.login_path} __ #{iauth.account_sessions_path} __ #{iauth.signup_path}"
        end

        def redirect_login_or_root
          store_location
          if current_user
           redirect_to main_app.root_path
          else
           redirect_to iauth.login_path
          end
        end
        
        def detect_url(params)
          begin
            main_app.url_for params
          rescue 
            MOUNTED_ROUTES.each do|mr|
              mounted_route  = send(mr[:name].to_sym)
              return mounted_route.url_for params rescue next
            end
            raise $!
          end
        end

    end
  end
end
ActionController::Base.send :include, Rorshack::Support::ControllerExt
