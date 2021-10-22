Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :tasks
  root 'tasks#index'

  get '*not_found', to: 'application#routing_error', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }  
  post '*not_found', to: 'application#routing_error', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }  

end
