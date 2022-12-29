# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#auth'
  delete '/logout', to: 'sessions#logout'

  get '/admin' => 'users#index'
  scope :admin do
    resources :users
  end

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
