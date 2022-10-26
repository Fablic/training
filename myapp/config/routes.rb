# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :tasks
  resources :labels, except: %i[show]
  resources :task_labels, only: %i[new] do
    collection do
      post :attach_labels
    end
  end

  get '/admin' => 'admin/users#index'
  namespace :admin do
    resources :users
  end
end
