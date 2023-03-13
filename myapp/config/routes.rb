Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :users, path: '/admin/users'

  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'
end
