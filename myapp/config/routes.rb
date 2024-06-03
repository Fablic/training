Rails.application.routes.draw do
  get 'users/signup'
  get 'users/signin'
  get 'users/signout'
  post 'users/create'
  root 'tasks#index'
  resources :tasks
end
