Rails.application.routes.draw do
  resources :tasks
  resources :users, only: [:new, :create]
  resources :labels, only: [:create]

  root 'tasks#index'

  # Admin Routes
  namespace :admin do
    resources :users
  end 

  # Routes for login/logout
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # Routes for error handling
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
