# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  get 'session', to: 'session#new'
  delete 'session', to: 'session#destroy'
  post 'session', to: 'session#create'
  patch 'session/change_role', to: 'session#change_role'

  namespace :admin do
    resources :users
    resources :tasks, only: %i[index show edit update destroy]
    get 'role', to: 'role#index'
  end
end
