# frozen_string_literal: true

Rails.application.routes.draw do
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  root to: 'tasks#index'
  resources :tasks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
