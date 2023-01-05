module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.user = User.find(session[:user_id]) if session[:user_id]
    end
  end
end
