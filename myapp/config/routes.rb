# frozen_string_literal: true

Rails.application.routes.draw do
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  root 'tasks#index'
  resources :tasks
end
