# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index create]
  post '/users/login' => 'users#login'
  post '/users/logout' => 'users#logout'
  resources :tasks
  resources :labels
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
