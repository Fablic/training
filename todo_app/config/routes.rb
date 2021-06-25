# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  get '*path', controller: :application, action: :routing_error
end
