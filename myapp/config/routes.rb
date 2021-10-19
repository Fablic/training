Rails.application.routes.draw do
  root "tasks#index"
  get 'users/login' => "users#new"
  get 'users/logout' => "users#destroy"
  post 'users/login' => "users#create"
  resources :tasks,:only => [:index, :edit, :new, :create, :update,:destroy]

  # error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
