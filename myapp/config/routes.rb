Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :users, path: '/admin/users'
end
