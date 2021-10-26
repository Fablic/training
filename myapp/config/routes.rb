Rails.application.routes.draw do

  resources :tasks
  resources :users

  root 'tasks#index'

  get  '/signup',  to: 'users#new'
  get 'sessions/new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '*not_found', to: 'application#routing_error', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }  
  post '*not_found', to: 'application#routing_error', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }  

end
