Rails.application.routes.draw do
  resources :tasks, only: [:index, :new, :create, :edit, :update]
end
