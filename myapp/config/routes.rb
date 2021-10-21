Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'

  resources :tasks
  root 'tasks#index'
end
