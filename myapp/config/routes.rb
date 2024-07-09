# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :labels, only: %i[index]

  get 'session', to: 'session#new'
  post 'session', to: 'session#create'
  delete 'session', to: 'session#destroy'
  patch 'session/switch_role', to: 'session#switch_role'

  namespace :admin do
    resources :users
    resources :tasks, only: %i[index show edit update destroy]
    resources :labels, only: %i[index destroy]
    get 'role', to: 'role#index'
  end
end
