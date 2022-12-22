# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'tasks#index'

  resources :tasks do
    member do
      patch :start
      patch :complete
    end
  end
end
