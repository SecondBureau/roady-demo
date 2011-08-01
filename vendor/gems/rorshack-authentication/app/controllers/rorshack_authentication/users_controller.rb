module RorshackAuthentication
  class UsersController < ApplicationController
    before_filter :redirect_root_unless_is_current_user , :except => [:index]
    
    def show
      @user = current_user
    end
    
    def edit
      @user = User.find_by_id(params[:id])
      @user.build_avatar if @user.avatar.nil?
    end

    def update
      unless current_user.is_of_role?("administrators")
        @user = User.find_by_id(params[:id])
        if @user.update_attributes(params[:user])
          flash[:notice] = t("user.updated")
          redirect_to iauth.user_path(current_user)
        else
          render 'edit'
        end
      else
        super
      end
    end
    
  private

    def redirect_root_unless_is_current_user
      unless signed_in? && current_user == User.find_by_id(params[:id])
        redirect_to main_app.root_path
      end
    end
  end
end
