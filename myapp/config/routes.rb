Rails.application.routes.draw do
  root 'tasks#index'

  get '/login', to: 'logins#top'
  post '/login', to: 'logins#login'
  delete 'logout', to: 'logins#logout'

  scope :admin do
    resources :users
    get '/', to: 'users#index'
  end
  resources :tasks

  match '*path', to: 'application#render404', via: :all
end
