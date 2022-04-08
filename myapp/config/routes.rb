Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  root to: 'tasks#index'
  resources :tasks
end
