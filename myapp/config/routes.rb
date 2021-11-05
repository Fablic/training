# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :labels

  # For Session controller
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # For Maintenance mode
  get 'maintenance' => 'maintenances#index', :as => :maintenance_index

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
