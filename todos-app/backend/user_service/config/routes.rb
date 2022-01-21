# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  get '/current-user', to: 'auth#logged_in_user'
  post '/login', to: 'auth#login'
end
