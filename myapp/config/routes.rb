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
  get 'admin', to: 'users#admin'
  # admin create user
  post 'admin', to: 'users#create_user'
  # admin new user
  get 'admin/new', to: 'users#new_user'
  # use users#create, #destroy only
  resources :users, only: [:create, :destroy]
  resources :tasks
end
