# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'tasks#index'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create]

  resources :tasks do
    member do
      patch :start
      patch :complete
    end
  end
end
