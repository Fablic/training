Rails.application.routes.draw do
  resources :tasks do
    post :add_label
    post :delete_label # verb delete doesn't seem  to support for ajax request
  end

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
