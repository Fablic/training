Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :tags
  resources :users, path: '/admin/users'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
