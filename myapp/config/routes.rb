Rails.application.routes.draw do
  # login page
  get 'login', to: 'sessions#new'
  # login
  post 'login', to: 'sessions#create'
  # logout
  delete 'logout', to: 'sessions#destroy'
  # index page
  root 'tasks#index'
  # signup page
  get 'users/signup', to: 'users#new'
  # admin page
  get 'users/admin', to: 'users#admin'
  # use users#create, #destroy only
  resources :users, only: [:create, :destroy]
  resources :tasks
end
