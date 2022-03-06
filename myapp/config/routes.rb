Rails.application.routes.draw do
  get root to: 'home#index'

  resources :board

  namespace :api do
    resources :board
    resources :task, except: %i[get show post]
    get 'board/:board_id/tasks', to: 'task#get'
    post 'board/:board_id/task', to: 'task#create'
  end
end
