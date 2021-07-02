Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
