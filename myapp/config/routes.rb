Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
