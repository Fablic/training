Rails.application.routes.draw do
  root "tasks#index"

  get "/tasks", to: "tasks#index"
end
