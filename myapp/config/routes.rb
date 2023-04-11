Rails.application.routes.draw do
  resources :labels
  resources :users
  resources :tasks

  resources :task_labels, only: %i[new] do
    collection do
      post :attach_labels
    end
  end

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get    '/logout',  to: 'sessions#destroy'
  root   'tasks#index'

  get    '/admin' => 'users#index'
  scope :admin do
    resources :users
  end
end
