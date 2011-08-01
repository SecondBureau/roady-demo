RoadyDemo::Application.routes.draw do
  resources :users
  resources :events
  scope "(/:locale)" do
    mount RorshackAdminUi::Engine => "/iadmin", :as => "iadmin"
  end

  mount RorshackAuthentication::Engine => "/iauth", :as => "iauth"

  root :to => "events#index"
end
