Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
end
