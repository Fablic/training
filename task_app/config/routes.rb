# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :tasks, except: %i[show]

  namespace :admin do
    root to: 'users#index'
    resources :users, except: %i[show] do
      get :tasks, on: :member
    end
  end
end
