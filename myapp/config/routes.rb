Rails.application.routes.draw do

  # 一覧
  get "/", to: "tasks#index"
  get "/tasks", to: "tasks#index"
  get "/tasks/index", to: "tasks#index"
  # 作成
  post "/tasks", to: "tasks#create"
  get "/tasks/new", to: "tasks#new", as: "new_task"
  # 編集
  get "/tasks/:id/edit", to: "tasks#edit", as: "edit_task"
  # 詳細
  get "/tasks/:id", to: "tasks#show", as: "task"
  # 更新
  patch "/tasks/:id", to: "tasks#update"
  # 削除
  delete "/tasks/:id", to: "tasks#destroy"
end
