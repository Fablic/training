Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'sessions#welcome'

  # Tasks
  resources :tasks

  # users
  get '/signup', to: 'users#new'

  resources :users

  get 'admin/users/add', to: 'users#add'
  get 'admin/users/list', to: 'users#index'

  # Session
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
