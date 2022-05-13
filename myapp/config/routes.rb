Rails.application.routes.draw do
  resources :tasks, path: '/' do
    collection do
      get :sort
    end
  end
end
