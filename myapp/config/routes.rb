Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root "tasks#index"
  resources :tasks

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
