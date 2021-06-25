Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  # get 'sessions/login'
  get 'welcome', to: 'sessions#welcome'
  # get 'users/new'
  # get 'users/create'
  root 'tasks#index'
  resources :tasks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
