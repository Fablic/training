class ApplicationController < ActionController::Base
  # ...
  # Custom 500 Internal Server Error handling
  # rescue_from Exception, with: :render_internal_server_error

  # Custom 404 Not Found error handling
  # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  # rescue_from ActionController::RoutingError, with: :render_not_found
  # rescue_from ActionController::UnknownFormat, with: :route_not_found

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  # Custom method to render the 404 Not Found error page
  def render_not_found(exception)
    # Log the exception for debugging purposes
    Rails.logger.error "404 Internal Server Error: #{exception.message}"
    render template: 'errors/404.html', status: :not_found
  end

  # Custom method to render the 500 Internal Server Error page
  def render_internal_server_error(exception)
    # Log the exception for debugging purposes
    Rails.logger.error "500 Internal Server Error: #{exception.message}"
    render template: 'errors/500.html', status: :internal_server_error
  end
  
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
