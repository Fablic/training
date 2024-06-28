# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  get 'session', to: 'session#new'
  post 'session', to: 'session#create'
  delete 'session', to: 'session#destroy'
end
