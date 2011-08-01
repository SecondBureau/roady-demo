require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActionController::Base do

  it "should contain methods in ActionControllerExt after include it" do

    %w[current_user_session  current_account  login_required  signed_in?].each do |instance_method|

      described_class.public_instance_methods.should include(instance_method)

    end

  end
  describe "#current_user_session" do
    it "return current_user_session" do
      
    end
  end
end
