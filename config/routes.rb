AcDP::Application.routes.draw do
  root "home#index"

  devise_for :users

  namespace :admin do
    resources :users
  end

  resources :users, only: [:show]
end
