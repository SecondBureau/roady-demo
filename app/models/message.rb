class Message < ActiveRecord::Base
  validates_presence_of :email , :content #, :title
  validates_length_of :content , :minimum => 6, :allow_blank => false
  validates_format_of :email , :with => Authlogic::Regex.email, :message => I18n.t('error_messages.email_invalid', :default => "should look like an email address.")
end
