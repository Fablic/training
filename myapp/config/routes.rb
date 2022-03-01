Rails.application.routes.draw do
  root to: 'tasks#list'
  resources :tasks
end
