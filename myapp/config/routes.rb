Rails.application.routes.draw do
  # ログイン、ログアウト関連
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # タスク関連
  resources :tasks
  root to: 'tasks#index'

  # ラベル関連
  resources :labels
end
