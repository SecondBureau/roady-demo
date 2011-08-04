class MessagesController < ApplicationController
  def create
    @message = Message.new(params[:message])
    @event = Event.unexpired.of_locale_or_default.find_by_code(params[:ec])
    if_is_visitee_then do |uid|
      User.callback_invitee!(:offer , uid) if is_first_time_offer?
      mark_session
    end
    respond_to do|f|
      f.js{
        if @message.save
              tplt = :create_success
              @message = Message.new
           else
              tplt = :create_failure
           end
        render tplt
      }
    end
  end


private

  def if_is_visitee_then
    if is_from_invited?
      yield( abstract_uid_from_session ) if block_given?
    end
  end

  def abstract_uid_from_session
    session["#{params[:ec]}_invitor_uid".to_sym]
  end

  def is_from_invited?
     params[:ec].present? &&
     session[:invited_ec].present? &&
     session[:invited_ec] == params[:ec] &&
     Event.unexpired.exists?(:code => params[:ec])
  end

  def mark_session
    session["#{params[:ec]}_offered_at".to_sym] = Time.current.to_s(:db)
  end

  def is_first_time_offer?
    session["#{params[:ec]}_offered_at".to_sym].nil?
  end
end
