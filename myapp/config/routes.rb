Rails.application.routes.draw do
  get 'sessions/new'
  resources :tasks
  root to: 'tasks#index'
end
