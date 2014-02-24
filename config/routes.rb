AcDP::Application.routes.draw do
  root "users#show_current"

  devise_for :users

  namespace :admin do
    resources :users do
      member do
        delete "delete_avatar"
      end
    end
  end

  resources :users, only: [:show] do
  	collection do
    	get 'current' => "users#show_current", as: :current_user
      get 'current/edit' => "users#edit_current", as: :current_user_edit
      patch 'current' => "users#update_current", as: :current_user_update
  	end
  end
end
