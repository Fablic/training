Rails.application.routes.draw do
  get 'sessions/new'
  resources :tasks
  root 'tasks#index'

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
