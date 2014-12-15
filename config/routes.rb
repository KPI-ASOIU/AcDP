AcDP::Application.routes.draw do
  opinio_model

  resources :news_posts do
    member do
      delete 'icon'
    end
    collection do
      get 'tags/:tag' => 'news_posts#index', as: 'tag'
      get 'categories/:category' => 'news_posts#index', as: 'category'
      get 'categories/group/:group_id' => 'news_posts#index', as: 'group'
    end
  end

  get 'calendar', to: 'calendar'
  get 'calendar/day/:date', to: 'calendar#day', as: 'day'
  get 'documents', to: 'documents#index'

  get 'documents/tree/:docdir/:type', to: 'documents#jstree'

  get 'documents/search' => 'documents#search', as: 'doc_search'
  get 'documents/shared', to: 'documents#shared'
  get 'documents/shared/:user_id', to: 'documents#shared', as: 'document_shared_root'
  get 'documents/shared/:user_id/:id', to: 'documents#shared', as: 'document_shared'
  post 'documents', to: 'documents#new', as: 'new_document'
  post 'documents/:id', to: 'documents#new', as: 'document_new'
  get 'documents/get_file_info', to: 'documents#get_file_doc_id', as: 'get_file_doc_id'
  get 'documents/:id', to: 'documents#index', as: 'document'

  patch 'documents/update', to: 'documents#update'
  post 'documents/change_file', to: 'documents#change_file'
  post 'documents/update_lists', to: 'documents#update_lists'
  delete 'documents/file/:delete_id', to: 'documents#delete_file', as: 'document_delete_file'
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

  post 'conversations/:id/attach_doc/:doc_id' => 'conversations#attach_doc', as: :conv_doc_attach
  post 'conversations/:id/detach_doc/:doc_id' => 'conversations#detach_doc', as: :conv_doc_detach

  resources :contacts, only: [:index, :create, :destroy]

  resources :tasks
  post 'tasks/:id' => 'tasks#update_checklist', as: :update_checklist

  resources :events

  get 'activity' => 'application#panel_activity', as: :activity_popover
end
