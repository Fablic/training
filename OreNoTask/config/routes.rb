# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  root 'tasks#index'
  resources :tasks
  get 'search' => 'tasks#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
