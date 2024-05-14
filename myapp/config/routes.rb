Rails.application.routes.draw do
  scope(path_name: {index: ""}) do
    resources :tasks, only: [:index, :new, :create, :show, :edit], path: "/"
  end
end
