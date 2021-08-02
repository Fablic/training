Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  get 'signup', to: 'users#new'
  post 'users/create', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end

  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
