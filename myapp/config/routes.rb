Rails.application.routes.draw do
  resources :task_labels
  resources :labels
  resources :users
  resources :tasks

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get    '/logout',  to: 'sessions#destroy'
  root   'tasks#index'

  get    '/admin' => 'users#index'
  scope :admin do
    resources :users
  end

end
