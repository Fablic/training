# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks, path: '/'
  get    'sessions/login', to: 'sessions#new', as: :login_form
  post   'sessions/login', to: 'sessions#create', as: :login
  delete 'sessions/logout', to: 'sessions#destroy', as: :logout
  # resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
