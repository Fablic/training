# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  root 'tasks#index'
  resources :tasks

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  scope '/admin' do
    resources :users
  end
  # namespace :admin do
  #   resources :users
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
