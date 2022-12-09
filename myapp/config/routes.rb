# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks do
    collection do
      get 'search'
    end
  end

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
