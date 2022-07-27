# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :_render503, if: :maintenance_mode?

  # error handle
  rescue_from Exception, with: :_render500
  rescue_from ActiveRecord::RecordNotFound, with: :_render404
  rescue_from ActionController::RoutingError, with: :_render404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render404(error = nil)
    logger.info "Rendering 404 with excaption: #{error.message}" if error
    render 'errors/404.html', status: :not_found
  end

  def _render500(error = nil)
    logger.info "Rendering 500 with exception: #{error.message}" if error
    render 'errors/500.html', status: :internal_server_error
  end

  def logged_in_user
    return if logged_in?

    redirect_to login_path
  end

  def maintenance_mode?
    maintenance_mode = Constant.find_by(key: 'maintenance_mode')
    return true if maintenance_mode.value
  end

  def _render503(error = nil)
    logger.info "Rendering 503 with exception: #{error.message}" if error
    render 'errors/503.html', content_type: 'text/html', status: :service_unavailable
  end
end
