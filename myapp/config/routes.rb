# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :tasks do
    get :search, on: :collection
  end

  # for error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
