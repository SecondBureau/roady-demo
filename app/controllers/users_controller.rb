class UsersController < ApplicationController
  before_filter :redirect_root_unless_is_current_user , :except => [:index]
  
  def show
    @user = current_user
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    if_is_visitee_then do|uid|
      if is_first_time_signup?
        @invitor = User.callback_invitee!(:signup , uid)
        @user.invitor = User.where(:uid => uid ).first
        @user.save
      end
      mark_session
    end
    @user.build_avatar if @user.avatar.nil?
  end

  def update
    unless current_user.is_of_role?("administrators")
      @user = User.find_by_id(params[:id])
      if @user.update_attributes(params[:user])
        flash[:notice] = t("user.updated")
        redirect_to main_app.user_path(current_user)
      else
        render 'edit'
      end
    else
      super
    end
  end
  
private

  def is_from_invited?
    session[:invitor_uid].present? &&
    User.exists?(:uid => session[:invitor_uid] )
  end
  
  def is_first_time_signup?
    session[:visitee_signup_at].nil?
  end

  def if_is_visitee_then
    if is_from_invited?
      yield(session[:invitor_uid]) if block_given?
    end
  end
  
  def mark_session
    session[:visitee_signup_at] = Time.current.to_s
    session[:invitor_uid] = nil
  end

  def redirect_root_unless_is_current_user
    unless signed_in? && current_user == User.find_by_id(params[:id])
      redirect_to main_app.root_path
    end
  end
end
