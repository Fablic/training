Rails.application.routes.draw do
  scope(path_name: {index: ""}) do
    resources :tasks, path: "/"
  end
end
