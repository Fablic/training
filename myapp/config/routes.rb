Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to:'tasks#list', as:'tasks'
  get 'tasks/new'
  get 'tasks/show/:id', to:'tasks#show', as:'tasks_show'
  get 'tasks/edit/:id', to:'tasks#edit', as:'tasks_edit'
  post 'tasks/create'
  patch 'tasks/update/:id', to:'tasks#update', as:'tasks_update'
  delete 'tasks/destroy/:id', to:'tasks#destroy', as:'tasks_destroy'
end
