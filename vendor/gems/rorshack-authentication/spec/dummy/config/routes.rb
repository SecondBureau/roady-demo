Rails.application.routes.draw do

  mount RorshackAuthentication::Engine => "/authentication"
end
