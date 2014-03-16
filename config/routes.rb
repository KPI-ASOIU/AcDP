AcDP::Application.routes.draw do
  root "users#show_current"

  devise_for :users

  namespace :admin do
    resources :users do
      member do
        delete "avatar"
      end
    end
    resources :groups
  end

  resources :users, only: [:show] do
  	collection do
    	get 'current' => "users#show_current", as: :current_user
      get 'current/edit' => "users#edit_current", as: :current_user_edit
      patch 'current' => "users#update_current", as: :current_user_update
      delete 'current' => "users#avatar", as: :current_user_avatar
  	end
  end

  resources :conversations, only: [:create, :index, :destroy] do
    resources :messages, only: [:index, :create]
  end
end
