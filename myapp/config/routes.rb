Rails.application.routes.draw do
  get 'login' => 'login#index'
  get 'logout' => 'login#logout'
  post 'login' => 'login#auth'
  root 'tasks#index'
  resources :tasks

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
