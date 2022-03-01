Rails.application.routes.draw do
  root to: 'tasks#list'
  resources :tasks
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
