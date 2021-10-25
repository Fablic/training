# frozen_string_literal: true

Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/admin/users', to: 'users#index'
  post '/admin/users/new(.:format)', to: 'users#create', as: 'create_user'
  get '/admin/users/new(.:format)', to: 'users#new', as: 'new_user'
  get '/admin/users/:id(.:format)', to: 'users#show', as: 'admin_user'
  get '/admin/users/:id/edit(.:format)', to: 'users#edit', as: 'edit_user'
  delete '/admin/users/:id(.:format)', to: 'users#destroy', as: 'delete_user'
  patch '/admin/users/:id(.:format)', to: 'users#update', as: 'update_user'
  get 'sessions/new'
  root 'tasks#index'
  resources :tasks
  get 'search' => 'tasks#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
