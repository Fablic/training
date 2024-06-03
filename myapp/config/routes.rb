Rails.application.routes.draw do
  get 'users/signup'
  get 'users/signin'
  get 'users/signout'
  root 'tasks#index'
  resources :tasks
end
