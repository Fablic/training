Rails.application.routes.draw do
  #root
  root "tasks#index"
  #task-path
  resources :tasks
end
