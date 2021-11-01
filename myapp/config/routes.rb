# frozen_string_literal: true

Rails.application.routes.draw do
  resources :labels
  resources :tasks

  scope '/admin' do
    resources :users
  end

  root to: 'tasks#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'maintenance' => 'sessions#maintenance'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
