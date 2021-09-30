Rails.application.routes.draw do
  #root
  root "tasks#index"
  #task-path
  resources :tasks

  # error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
