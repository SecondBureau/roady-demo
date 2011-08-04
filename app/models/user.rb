if Rails.env.development? or Rails.env.test?
  require "md5"
else
  require "digest/md5"
  MD5 = Digest::MD5
end
class User < ActiveRecord::Base
  include RorshackPermission::UserModelExt
  after_create :set_default_role
  has_one :account , :class_name => "RorshackAuthentication::Account" , :dependent => :destroy
  has_one :avatar , :class_name => "Image" , :as => "image_owner" , :dependent => :destroy
  
  has_many :invitees , :class_name => "User" , :foreign_key => "invitor_id"
  belongs_to :invitor , :class_name => "User" , :foreign_key => "invitor_id"
  
  has_many :event_tracks
  
  accepts_nested_attributes_for :account , :allow_destroy => true
  accepts_nested_attributes_for :avatar , :allow_destroy => true
  
  before_validation :make_avatar
  before_validation :make_uid
  
  def self.callback_invitee!( action , uid , event_code )
    if invitor = find_by_uid(
       uid) && event = Event.of_locale_or_default.unexpired.has_offer_left.find_by_code( event_code )
      case action
        when :invite_registered_bonus
          EventTrack.update_bonus!( invitor , event , Setting.local_value("invite_registered_bonus").to_i )
        when :invite_unregister_bonus
          EventTrack.update_bonus!( invitor , event , Setting.local_value("invite_unregister_bonus").to_i )
        when :signup
          EventTrack.update_bonus!( invitor , event , Setting.local_value("invitee_signup_bonus").to_i )
      end
    end
  end
  def email
    account.email
  end
  
  def friends
    ([invitor] | invitees).compact
  end
  
  protected
  
  def make_uid
    self.uid = MD5.hexdigest( Time.current.to_s + rand(10000).to_s ) if self.uid.blank?
  end
  
  def make_avatar
    self.build_avatar if self.avatar.nil?
  end
  
  def set_default_role
    self.role!( Role.default ) if self.role.nil?
  end
  
end
