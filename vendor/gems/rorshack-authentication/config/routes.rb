RorshackAuthentication::Engine.routes.draw do
  resources :authentications , :only => [:create , :destroy , :failure]
  resources :accounts , :only => [:new , :create , :edit]
  resources :account_sessions , :only => [:new , :create , :destroy]
  resources :passwords , :only => [:new , :show, :create , :edit]
  match '/login'    => 'account_sessions#new'
  match '/logout'   => 'account_sessions#destroy'
  match '/signup'   => 'accounts#new'
  match "/auth/:provider/callback"  => "authentications#create" , :as => :oauth_callback
  match "/auth/failure"             => "authentications#failure" , :as => :oauth_failure
end
