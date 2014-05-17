AcDP::Application.routes.draw do
  get "calendar/index"
  get 'documents', to: 'documents#index'
  get 'documents/shared', to: 'documents#shared'
  get 'documents/shared/:user_id', to: 'documents#shared', as: 'document_shared_root'
  get 'documents/shared/:user_id/:id', to: 'documents#shared', as: 'document_shared'
  get 'documents/:id', to: 'documents#index', as: 'document'
  post 'documents', to: 'documents#new'
<<<<<<< HEAD
  post 'documents/update', to: 'documents#update'
  post 'documents/update_access', to: 'documents#update_access'
  post 'documents/:id', to: 'documents#new', as: 'document_new'
  delete 'documents/delete/:delete_id', to: 'documents#delete', as: 'document_delete_root'
  delete 'documents/:id/delete/:delete_id', to: 'documents#delete', as: 'document_delete'
=======
>>>>>>> dfa7a7cb27d974761af39922a6d67278dadaffcb
  get 'calendar', to: 'calendar'
  delete 'documents', to: 'documents#delete'
  get 'calendar', to: 'calendar'
  delete 'documents', to: 'documents#delete'
  post 'documents/update', to: 'documents#update'
  post 'documents/update_access', to: 'documents#update_access'
  post 'documents/:id', to: 'documents#new'

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

  resources :contacts, only: [:index, :create, :destroy]

  resources :tasks
end
