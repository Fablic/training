Rails.application.routes.draw do
  get 'users/new'
  get 'sessions/new'
  resources :tasks
  root 'tasks#index'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
