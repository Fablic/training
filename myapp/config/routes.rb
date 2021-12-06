Rails.application.routes.draw do
  get 'user/new'
  get 'sessions/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  resources 'tasks'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'
end
