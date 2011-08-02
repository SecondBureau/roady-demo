RoadyDemo::Application.routes.draw do
  resources :users
  scope "(/:locale)" do
    resources :events
    resources :messages
    mount RorshackAdminUi::Engine => "/iadmin", :as => "iadmin"
    match "/api/:ec/:uid" => "api#show" , :as => "event_api"
  end
  mount RorshackAuthentication::Engine => "/iauth", :as => "iauth"

  root :to => "events#index"
end
