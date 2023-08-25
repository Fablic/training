Rails.application.routes.draw do
  resources :tasks
  resources :users, only: [:new, :create]
  root 'tasks#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
