Rails.application.routes.draw do
  get 'tasks/index'
  get 'tasks/new'
  get 'tasks/show'
  get 'tasks/edit'
  resources :tasks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
