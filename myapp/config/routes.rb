Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    resources :tasks

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    root "tasks#index"

    match "/:code",
    to: "errors#show",
    via: :all,
    constraints: { 
      code: Regexp.new(
        ErrorsController::VALID_STATUS_CODES.join("|")
      ) 
    }
  end
end
