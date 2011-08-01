require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
class Account < ActiveRecord::Base
  include  RorshackAuthentication::AccountModelMethods
end
describe  RorshackAuthentication::AccountModelMethods do
  describe Account , "before_validation" do
    describe "before_validation :clean_data" do
      it "should coerce downcase email" do
        u = Account.make_unsaved(:email => "ABC@gmail.com")
        u.valid?
        u.email.should == "abc@gmail.com"
      end
    end
    describe "before_validation :set_username" do
      u = Account.make_unsaved(:email => "ABC@gmail.com" , :username => nil)
      u.valid?
      u.username.should == "abc@gmail.com"
    end
  end
  describe Account , "has_authentication" do
    it "should return false if has not authentication link to facebook" do
      auth = Authentication.make(:provider => "twitter")
      auth.account.has_authentication(:facebook).should be_false
    end
    it "should return true if has authentication link to facebook" do
      auth = Authentication.make(:provider => "facebook")
      auth.account.has_authentication(:facebook).should be_true
    end
  end
  describe Account , "get_authentication" do
    it "should return nil if has not authentication link to facebook" do
      auth = Authentication.make(:provider => "twitter")
      auth.account.get_authentication(:facebook).should be_nil
      Account.make.get_authentication(:facebook).should be_nil
    end
    it "should return authentication if has authentication link to facebook" do
      auth = Authentication.make(:provider => "facebook")
      auth.account.get_authentication(:facebook).should == auth
    end
  end
  describe Account , "self.find_or_create_from_omniauth" do
    it "should create a user if username did not existed" do
      lambda{
        u = Account.find_or_create_from_omniauth({"user_info" => {"name" => "testuser"}})
        u.username.should == 'testuser'
      }.should change(Account , :count).by(1)
    end
    it "should not create a user if username existed" do
      Account.make(:username => "hhhh")
      lambda{
        u = Account.find_or_create_from_omniauth({"user_info" => {"name" => "hhhh"}})
        u.username.should == 'hhhh'
      }.should change(Account , :count).by(0)
    end
  end
end
