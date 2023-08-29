Rails.application.routes.draw do
  get 'maintenance/show'
  resources :tasks
  resources :users, only: [:new, :create]
  root 'tasks#index'

  # Admin Routes
  namespace :admin do
    resources :users
  end 

  # Routes for login/logout
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # Routes for maintenance mode
  get '/maintenance', to: 'maintenance#show'

  # Routes for error handling
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
