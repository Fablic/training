Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  
  # 404/500エラーページ
  get '*path' => 'application#render_404'
  post '*path' => 'application#render_404'
end
