# frozen_string_literal: true

Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'new_user'
  post 'signup', to: 'users#create', as: 'users'
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy', as: :logout
  root 'tasks#index'
  resources :tasks
end
