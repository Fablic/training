Rails.application.routes.draw do
  root to: 'tasks#list'
  resources :tasks
  resources :users
  resources :labels

  get  'login' => 'sessions#new', as: :login
  post 'login' => 'sessions#create'
  get  'logout' => 'sessions#destroy', as: :logout

  get 'api/tasks/board' => 'tasks#board_api'
  get 'search' => 'tasks#search'
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
