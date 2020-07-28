Rails.application.routes.draw do
  resources :tasks

  root 'tasks#index'

  get 'login' => 'session#new', as: :login
  post 'session' => 'session#create', as: :session
  delete 'session' => 'session#destroy', as: :logout


  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
  patch '*not_found' => 'application#routing_error'
  delete '*not_found' => 'application#routing_error'

end
