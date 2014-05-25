AcDP::Application.routes.draw do
  opinio_model
  get 'documents', to: 'documents#index'
  get 'documents/shared', to: 'documents#shared'
  get 'documents/shared/:user_id', to: 'documents#shared', as: 'document_shared_root'
  get 'documents/shared/:user_id/:id', to: 'documents#shared', as: 'document_shared'
  get 'documents/:id', to: 'documents#index', as: 'document'
  post 'documents', to: 'documents#new'
  patch 'documents/update', to: 'documents#update'
  post 'documents/update_lists', to: 'documents#update_lists'
  post 'documents/:id', to: 'documents#new', as: 'document_new'
  delete 'documents/delete/:delete_id', to: 'documents#delete', as: 'document_delete_root'
  delete 'documents/:id/delete/:delete_id', to: 'documents#delete', as: 'document_delete'

  root "users#show_current"

  devise_for :users

  namespace :admin do
    resources :users do
      member do
        delete "avatar"
      end
    end
    resources :groups
    resources :doctypes
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

  resources :events
end
