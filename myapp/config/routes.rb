Rails.application.routes.draw do
  get root :to => 'home#index'
  get 'board/:board_id', to: 'board#index'
  scope "api" do
    get 'board/:board_id', to: 'api/board#get'
    get 'board/:board_id/tasks', to: 'api/task#get'
    post 'board/:board_id/task', to: 'api/task#post'
    patch 'board/:board_id/task/:task_id', to: 'api/task#patch'
    delete 'board/:board_id/task/:task_id', to: 'api/task#delete'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
