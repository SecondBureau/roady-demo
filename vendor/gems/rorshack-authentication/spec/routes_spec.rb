require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "default routes for rorshack-authentication" do
  before do
    @routes = Rails.application.routes
  end

  describe "authenticate with openid" do
    it "should route to authentications#create if success" do
      @routes.recognize_path("/auth/facebook/callback" , :method => :get).should ==
      {:provider=>"facebook", :controller=>"authentications", :action=>"create"}
    end
    it "should route to authentications#destroy if failure" do
      @routes.recognize_path("/auth/failure" , :method => :get).should ==
      {:controller=>"authentications", :action=>"failure"}
    end
  end

  describe "login logout signup" do
    it "should route to account_sessions#new if login" do
      @routes.recognize_path("/login" , :method => :get).should ==
      {:controller=>"account_sessions", :action=>"new"}
    end
    it "should route to account_sessions#destroy if logout" do
      @routes.recognize_path("/logout" , :method => :get).should ==
      {:controller=>"account_sessions", :action=>"destroy"}
    end
    it "should route to accounts#new if signup" do
      @routes.recognize_path("/signup" , :method => :get).should ==
      {:controller=>"accounts", :action=>"new"}
    end
  end

  describe "resources :accounts , :only => [:new , :create , :edit]" do
    it "should route to accounts#new if get accounts/new" do
      @routes.recognize_path("/accounts/new" , :method => :get).should ==
      {:controller=>"accounts", :action=>"new"}
    end
    it "should route to accounts#create if post accounts" do
      @routes.recognize_path("/accounts" , :method => :post).should ==
      {:controller=>"accounts", :action=>"create"}
    end
    it "should route to accounts#edit if get accounts/:id/edit" do
      @routes.recognize_path("/accounts/0/edit" , :method => :get).should ==
      {:controller=>"accounts", :action=>"edit" , :id => "0"}
    end
  end

  describe "resources :account_sessions , :only => [:new , :create , :destroy]" do
    it "should route to account_sessions#new if get account_sessions/new" do
      @routes.recognize_path("/account_sessions/new" , :method => :get).should ==
      {:controller=>"account_sessions", :action=>"new"}
    end
    it "should route to account_sessions#create if post account_sessions" do
      @routes.recognize_path("/account_sessions" , :method => :post).should ==
      {:controller=>"account_sessions", :action=>"create"}
    end
    it "should route to account_sessions#destroy if delete account_sessions/:id" do
      @routes.recognize_path("/account_sessions/0" , :method => :delete).should ==
      {:controller=>"account_sessions", :action=>"destroy" , :id => "0"}
    end
  end
  
  describe "resources :passwords , :only => [:new , :show, :create , :edit]" do
    it "should route to passwords#new if get passwords/new" do
      @routes.recognize_path("/passwords/new" , :method => :get).should ==
      {:controller=>"passwords", :action=>"new"}
    end
    it "should route to passwords#create if post passwords" do
      @routes.recognize_path("/passwords" , :method => :post).should ==
      {:controller=>"passwords", :action=>"create"}
    end
    it "should route to passwords#show if get passwords/:id" do
      @routes.recognize_path("/passwords/0" , :method => :get).should ==
      {:controller=>"passwords", :action=>"show" , :id => "0"}
    end
    it "should route to passwords#edit if get passwords/:id/edit" do
      @routes.recognize_path("/passwords/0/edit" , :method => :get).should ==
      {:controller=>"passwords", :action=>"edit" , :id => "0"}
    end
  end
  
  describe "resources :authentications , :only => [:create , :destroy , :failure]" do
    it "should route to authentications#create if post authentications" do
      @routes.recognize_path("/authentications" , :method => :post).should ==
      {:controller=>"authentications", :action=>"create"}
    end
    it "should route to authentications#destroy if delete authentications/:id" do
      @routes.recognize_path("/authentications/0" , :method => :delete).should ==
      {:controller=>"authentications", :action=>"destroy" , :id => "0"}
    end
  end
end
