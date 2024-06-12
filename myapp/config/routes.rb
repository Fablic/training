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
  # admin page
  get 'admin', to: 'users#admin'
  # admin create user
  post 'admin', to: 'users#create_user'
  # admin user tasks
  get 'admin/:id/tasks', to: 'users#user_tasks', as: :user_tasks
  # admin new user
  get 'admin/new', to: 'users#new_user'
  # use users #destroy only
  resources :users, only: [:destroy]
  resources :tasks
end
