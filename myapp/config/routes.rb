# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :tasks
end
