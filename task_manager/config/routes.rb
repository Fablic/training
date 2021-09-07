# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'tasks#index'

  resources :tasks
  resources :users, only: %i[new create show update edit destroy]

  namespace :admin do
    resources :users, only: %i[index show edit update destroy] do
      resources :tasks, only: [:index]
    end
  end

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
end
