Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get root to: 'home#index'
  scope '/:locale', locale: /en|ja/ do
    resources :board

    scope :member do
      get 'login', to: 'member#login'
      post 'login', to: 'member#login_process'
      get 'logout', to: 'member#logout'
    end
  end

  namespace :api do
    resources :board
    resources :task, except: %i[get show post]
    get 'board/:board_id/tasks', to: 'task#get'
    post 'board/:board_id/task', to: 'task#create'
  end

end
