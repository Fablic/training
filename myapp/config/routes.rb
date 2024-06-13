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
  scope '/admin' do 
    # admin page
    get '/', to: 'users#admin', as: :admin
    # admin create user
    post '/', to: 'users#create_user'
    # admin user tasks
    get ':id/tasks', to: 'users#user_tasks', as: :user_tasks
    # admin new user
    get 'new', to: 'users#new_user', as: :new_user
    resources :users, only: [:edit, :update, :destroy]
  end
  resources :tasks
end
