Rails.application.routes.draw do
  resources :tasks
  resources :users
  root to: 'tasks#index'
  resource :sessions, only: %i[new create destroy]
  match '/sign_in',   to: 'sessions#new',     via: 'get'
  match '/sign_out',  to: 'sessions#destroy', via: 'delete'
  namespace :admin do
    resources :users
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
