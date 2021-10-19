Rails.application.routes.draw do
  get 'users/login' => "users#new"
  get 'users/logout' => "users#destroy"
  post 'users/login' => "users#create"
  #root
  root "tasks#index"

  #task.rb-path
  resources :tasks,:only => [:index, :edit, :new, :create, :update,:destroy]

  # error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
