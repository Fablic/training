# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks

  # for error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
