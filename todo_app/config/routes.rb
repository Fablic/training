# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/sign_up', to: 'users#new'
  post '/sign_up', to: 'users#create'

  get '*path', controller: :application, action: :routing_error
end
