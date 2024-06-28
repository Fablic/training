# frozen_string_literal: true

Rails.application.routes.draw do

  root to: 'tasks#index'
  resources :tasks

  get 'session', to: 'session#new'
  post 'session', to: 'session#create'
  delete 'session', to: 'session#destroy'

  namespace :admin do
    get 'dashboard/index'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
    get 'users/new'
    get 'users/create'
    get 'users/edit'
    get 'users/update'
    get 'users/destroy'
  end
end
