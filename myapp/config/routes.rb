Rails.application.routes.draw do
  resources :tasks, path: '/' do
    collection do
      get :sort
      get :search
    end
  end
end
