class ApiController < ApplicationController
  def show
    if is_from_invited?
      User.callback_invitee!(:invited , params[:uid]) if is_first_time_invited?
      mark_session
      redirect_to main_app.event_path(params[:ec])
    else
      redirect_to main_app.root_path
    end
  end
  
  private
  
  def mark_session
    session[:invited_ec] = params[:ec]
    session[:invitor_uid] = params[:uid]
    session["#{params[:ec]}_invited_at".to_sym] = Time.current.to_s(:db)
    session["#{params[:ec]}_invitor_uid".to_sym] = params[:uid]
  end
  
  def is_from_invited?
     params[:ec].present? && 
     Event.unexpired.exists?(:code => params[:ec]) &&
     params[:uid].present? &&
     User.exists?(:uid => params[:uid])
  end
  
  def is_first_time_invited?
    session["#{params[:ec]}_invited_at".to_sym].nil?
  end
end
