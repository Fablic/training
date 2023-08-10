# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'tasks/index'

  resources :tasks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Custom Error pages handling routes
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
