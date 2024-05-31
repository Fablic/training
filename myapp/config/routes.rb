# frozen_string_literal: true

Rails.application.routes.draw do
  if File.exist?(Rails.root.join("tmp", "maintenance.txt"))
    get "/", to: "static_pages#maintenance"
    match "*path", to: "static_pages#maintenance", via: :all
  else
    resources :tasks
    get "/", to: "tasks#index"
    get "login" => "sessions#new"
    post "login" => "sessions#create"
    delete "logout" => "sessions#destroy"
    get "*path", controller: "application", action: "render_404"
    post "*path", controller: "application", action: "render_404"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
