# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root to: 'users#new'
    resources :users do
      get 'tasks', on: :member
    end
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  root 'tasks#index'
  resources :tasks

  get '*path', controller: 'application', action: :render404
end
