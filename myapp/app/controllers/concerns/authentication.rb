# frozen_string_literal: true

module Authentication # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    helper_method :require_sign_in!, :signed_in?, :current_user
  end

  def require_sign_in!
    redirect_to session_path, alert: 'You must be logged in to access this section' unless signed_in?
  end

  def signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
