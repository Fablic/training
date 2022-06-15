Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'tasks#index'
  resources :tasks
  resources :labels, only: [:index, :update, :destroy, :create]

  namespace :admin do
    resources :users
    get '/users/tasks/:id', to: 'tasks#show', as: 'user_tasks'
  end
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
