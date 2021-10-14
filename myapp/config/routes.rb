Rails.application.routes.draw do
  #root
  root "tasks#index"
  #task.rb-path
  resources :tasks,:only => [:index, :edit, :new, :create, :update,:destroy]

  # error page
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
