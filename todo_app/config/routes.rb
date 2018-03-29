Rails.application.routes.draw do
  root 'tasks#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :tasks
  get 'tasks/index'

  namespace :admin do
    resources :users
    get 'users/:id/tasks' => 'users#tasks', as: :user_tasks
  end
end
