RoadyDemo::Application.routes.draw do
  resources :users
  resources :events
  scope "(/:locale)" do
    mount RorshackAdminUi::Engine => "/iadmin", :as => "iadmin"
  end

  mount RorshackAuthentication::Engine => "/iauth", :as => "iauth"

  # the root of the website
  root :to => "pages#index"
end
