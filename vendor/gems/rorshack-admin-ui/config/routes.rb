RorshackAdminUi::Engine.routes.draw do
  resources :admin_ui
  resources :admin , :only => [:index , :edit]
  match '/admin/:model_name'   => "admin_ui#index", :as => :admin_model, :requirements => { "model_name" => /[-_a-z0-9]/ }
  root :to => "admin#list"
end
