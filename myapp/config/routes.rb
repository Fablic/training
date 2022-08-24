Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  get 'search' => 'tasks#search'

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
