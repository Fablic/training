Rails.application.routes.draw do
  root to: 'task_schedule#index'
  resources :task_schedule
  scope '/admin' do
    resources :users
  end
  get '/login', to: 'sessions#new'
  get '/admin/login', to: 'sessions#new_admin'
  post '/login', to: 'sessions#create'
  post '/admin/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
