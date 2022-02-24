Rails.application.routes.draw do
  resources :tasks, except: :index
  root 'tasks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
