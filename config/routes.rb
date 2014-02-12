AcDP::Application.routes.draw do
  root "users#show_current"

  devise_for :users

  namespace :admin do
    resources :users
  end

  resources :users, only: [:show] do
  	collection do
    	get 'current' => "users#show_current", as: :current_user
  	end
  end
end
