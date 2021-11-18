# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  # resolve('Tasks') { [:tasks] }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
