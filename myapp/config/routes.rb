# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks do
    get :search, on: :collection
  end

  # for error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
