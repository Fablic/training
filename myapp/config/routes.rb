Rails.application.routes.draw do
  # signup page
  get 'signup', to: 'sessions#signup_new'
  # signup
  post 'signup', to: 'sessions#signup_create'
  # login page
  get 'login', to: 'sessions#new'
  # login
  post 'login', to: 'sessions#create'
  # logout
  delete 'logout', to: 'sessions#destroy'
  # index page
  root 'tasks#index'
  resources :tasks
end
