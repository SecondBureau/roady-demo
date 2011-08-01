module RorshackAdminUi
  class ApplicationController < ::ApplicationController
    before_filter :check_if_is_admin
    private 
      def check_if_is_admin
        unless signed_in? and current_user.is_of_role?(:administrators)
          redirect_to main_app.root_path
        end
    end
  end
end
