Rails.application.routes.draw do
  resources :tasks

  root 'tasks#index'

  get 'login' => 'session#new', as: :login
  post 'session' => 'session#create', as: :session
  delete 'session' => 'session#destroy', as: :logout

  namespace :admin do
    root 'top#index'
    resources :users do
      post :suspend
    end
  end

end
