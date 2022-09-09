# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks

  get '*not_found' => 'application#render_404'
end
