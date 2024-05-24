# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks
  resources :users
  get "admin" => "users#index"
  get "/" => "tasks#index"
  get "signup" => "users#new"
  post "signup" => "users#create"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  get "*path", controller: "application", action: "render_404"
  post "*path", controller: "application", action: "render_404"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
