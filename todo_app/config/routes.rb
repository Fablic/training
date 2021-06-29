# frozen_string_literal: true

Rails.application.routes.draw do
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy"
  get "signup" => "users#new"
  root "tasks#index"
  resources :tasks

  get "*path", controller: "application", action: "render_404"
end
