Rails.application.routes.draw do
  root to: 'tasks#list'
  resources :tasks
  get 'api/tasks/board' => 'tasks#board_api'
  get 'search' => 'tasks#search'
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
