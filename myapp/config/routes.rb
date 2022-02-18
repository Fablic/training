Rails.application.routes.draw do
  get root :to => 'home#index'

  resources :board
  
  namespace :api do
    resources :board
    resources :task, :except => [:get, :show]
    get 'board/:board_id/tasks', to: 'task#get'

  end
end
