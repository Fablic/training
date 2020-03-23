# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ja/ do
    root 'static#index'
    resources :static, only: [:index]
    resources :projects, only: [:show, :index, :create, :update, :destroy]
    resources :tasks, only: [:create, :update, :destroy]
    resources :search, only: [:index]

    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
  end

  get '*path', to: 'application#routing_error', via: :all
end
