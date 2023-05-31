Rails.application.routes.draw do
  get 'sessions/create'
  root to: 'tasks#index'
  resources :tasks do
    get :search, on: :collection
  end
  resources :users, path: '/admin/users'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
