Rails.application.routes.draw do
  root to: 'tasks#list'
  get 'tasks', to: 'tasks#index'
  get 'tasks/list', to: 'tasks#list', as: 'list_task'
  get 'tasks/new', to: 'tasks#new'
  get 'tasks/:id/show', to: 'tasks#show', as: 'show_task'
  get 'tasks/:id/edit', to: 'tasks#edit', as: 'edit_task'
  get 'api/tasks/:id/delete', to: 'tasks#destroy_api'

  post 'tasks', to: 'tasks#create', as: 'create_task'
  patch 'tasks/:id', to: 'tasks#update', as: 'update_task'
  delete 'tasks/:id', to: 'tasks#destroy', as: 'destroy_task'
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
