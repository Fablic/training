Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :tasks
  root to: 'tasks#index'

  # ラベル関連
  resources :labels

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
