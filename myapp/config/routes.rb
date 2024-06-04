Rails.application.routes.draw do
  # login page
  get 'login', to: 'sessions#new'
  # login
  post 'login', to: 'session#create'
  # logout
  delete 'logout', to: 'session#destroy'
  # index page
  root 'tasks#index'
  # signup page
  get 'users/signup', to: 'users#new'
  # use users#create only
  resources :users, only: [:create]
  resources :tasks
end
