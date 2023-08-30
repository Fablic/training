# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:todo Style/Documentation
  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # keep locale in urls
  def default_url_options
    { locale: I18n.locale }
  end

  # unless Rails.env.development?
  rescue_from ActiveRecord::StatementInvalid,   with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,     with: :_render_404
  rescue_from ActionController::RoutingError,   with: :_render_404
  # end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def check_authentication
    return if current_user

    redirect_to login_path
  end

  def check_admin_auth
    return if current_user&.is_admin

    flash[:alert] = 'Unauthorized!'
    redirect_to tasks_path
  end

  helper_method :current_user

  private

  def _render_404(exception = nil)
    Rails.logger.info "Rendering 404 with exception: #{exception.message}" if exception

    render 'errors/404', status: :not_found
  end

  def _render_500(exception = nil)
    Rails.logger.error "Rendering 500 with exception: #{exception.message}" if exception

    render 'errors/500', status: :internal_server_error
  end

  def current_user
    if session[:user]
      return @current_user ||= User.find(session[:user]['id'])
    end

    nil
  end
end
