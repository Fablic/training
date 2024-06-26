# frozen_string_literal: true

Rails.application.routes.draw do
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy', as: :logout
  root 'tasks#index'
  resources :tasks

  namespace :admin do
    root 'dashboard#index'
    resources :users do
      resources :tasks, only: %i[index exit update destory]
    end
  end
end
