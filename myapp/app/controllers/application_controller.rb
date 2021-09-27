class ApplicationController < ActionController::Base
  before_action :_check_maintenannce
  include SessionsHelper

  unless Rails.env.production?
    rescue_from Exception, with: :_render_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :_render_not_found
    rescue_from ActionController::RoutingError, with: :_render_not_found
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_not_found(exc = nil)
    logger.info "Rendering 404 with excaption: #{exc.message}" if exc

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render 'errors/404.html', status: :not_found, layout: 'error'
    end
  end

  def _render_server_error(exc = nil)
    logger.error "Rendering 500 with excaption: #{exc.message}" if exc

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render 'errors/500.html', status: :internal_server_error, layout: 'error'
    end
  end

  def _login_check
    return if logged_in?

    redirect_to login_url
  end

  def _check_maintenannce
    return unless File.exist?(Rails.public_path.join('maintenance.html'))

    redirect_to '/maintenance.html'
  end
end
