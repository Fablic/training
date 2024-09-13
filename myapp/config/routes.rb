# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'tasks#index'

  resources :tasks

  get   '/users', '/users/new', to: 'users#new'
  post  '/users', to: 'users#create'
  patch '/users/:id', to: 'users#update'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    get '/', to: 'users#index'

    resources :users

    get '/users/:id/tasks', to: 'tasks#index', as: 'user_tasks'
    delete '/tasks/:id', to: 'tasks#destroy', as: 'task'
  end

  # overrirde default error pages
  get '/404', to: 'errors#not_found', as: :not_found, via: :all
  get '/500', to: 'errors#internal_server_error', as: :internal_server_error, via: :all
  get '/errors/:status', to: 'errors#show', as: :error

  match '*path', to: 'errors#not_found', via: :all
end
