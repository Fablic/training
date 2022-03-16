Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks

  # get '*not_found' => 'application#routing_error'
  # post '*not_found' => 'application#routing_error'
end
