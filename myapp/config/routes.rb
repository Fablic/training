Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  get '/search' => 'tasks#search'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  # 404/500エラーページ
  get '*path' => 'application#render_404'
  post '*path' => 'application#render_404'

end
