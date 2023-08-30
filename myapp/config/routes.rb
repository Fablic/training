# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'tasks/index'

  namespace :admin do
    resources :users
  end

  resources :tasks

  get 'login' => 'auth#login'
  post 'login' => 'auth#authenticate'
  delete 'logout' => 'auth#logout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Custom Error pages handling routes
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
