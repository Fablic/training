# frozen_string_literal: true

Rails.application.routes.draw do
  get 'maintenance', to: 'static_pages#maintenance'
  resources :tasks
  get "/", to: "tasks#index"
  get "*path", controller: "application", action: "render_404"
  post "*path", controller: "application", action: "render_404"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
