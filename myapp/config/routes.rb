Rails.application.routes.draw do
  root "tasks#index"
  get 'sessions/login' => "sessions#new"
  get 'sessions/logout' => "sessions#delete"
  post 'sessions/login' => "sessions#create"
  resources :tasks,:only => [:index, :edit, :new, :create, :update, :destroy]

  # error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
