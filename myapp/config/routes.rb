Rails.application.routes.draw do
  get 'users/index'
  root to: 'tasks#index'
  resources :tasks do
    get :search, on: :collection
  end
end
