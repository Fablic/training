# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  # Added `rescue_from` here for the assignment, but it is planned to be removed
  # rescue_from StandardError, with: :render_internal_server_error
  # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  helper_method :current_user, :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def signed_in?
    !!current_user
  end

  def require_sign_in
    return if signed_in?

    redirect_to session_path
  end

  def render_not_found
    render file: Rails.root.join('public/404.html'), status: :not_found
  end

  def render_internal_server_error(exception)
    logger.error(exception.message)
    logger.error(exception.backtrace.join("\n"))

    render file: Rails.root.join('public/500.html'), status: :internal_server_error
  end

  private

  def after_sign_in_path_for(user)
    case user.role
    when 'admin'
      admin_dashboard_index_path
    else
      root_path
    end
  end
end
