Rails.application.routes.draw do |map|
  # get 'tasks/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get '/tasks'
  root :to => 'tasks#index'
  resources :tasks

  # タスク一覧
  post '/tasks/index' => 'tasks#index'
  post '/' => 'tasks#index'

  # タスク新規登録
  post '/tasks/new' => 'tasks#new'
  get '/tasks/new' => 'tasks#new'

  # タスク詳細
  post '/tasks/detail/:id(.:format)' => 'tasks#detail'
  get '/tasks/detail/:id(.:format)' => 'tasks#detail'

  # タスク編集画面
  post '/tasks/edit/:id(.:format)' => 'tasks#edit'
  get '/tasks/edit/:id(.:format)' => 'tasks#edit'

  # タスク削除画面
  post '/tasks/delete/:id(.:format)' => 'tasks#delete'
  get '/tasks/delete/:id(.:format)' => 'tasks#delete'

  # タスク削除実行
  post '/tasks/destroy/:id(.:format)' => 'tasks#destroy'
  get '/tasks/destroy/:id(.:format)' => 'tasks#destroy'
  
end
