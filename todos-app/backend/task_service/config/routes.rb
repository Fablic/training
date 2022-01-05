# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks
  delete '/tasks', to: 'tasks#destroy_all'
end
