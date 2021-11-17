# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :render503, if: :maintenance_mode?

  def maintenance_mode?
    File.exist?('on_maint')
  end

  unless Rails.env.development?
    rescue_from Exception,                      with: :render500
    rescue_from ActiveRecord::RecordNotFound,   with: :render404
    rescue_from ActionController::RoutingError, with: :render404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render404(err = nil)
    logger.info "Rendering 404 with excaption: #{err.message}" if err

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render 'errors/404.html', status: :not_found, layout: 'error'
    end
  end

  def render500(err = nil)
    logger.error "Rendering 500 with excaption: #{err.message}" if err

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render 'errors/500.html', status: :internal_server_error, layout: 'error'
    end
  end

  def render503
    if request.format.to_sym == :json
      render json: { error: '503 service_unavailable' }, status: :service_unavailable
    else
      render 'errors/503.html', status: :service_unavailable, layout: 'error'
    end
  end

  def ensure_logged_in
    redirect_to login_url unless logged_in?
  end

  def ensure_logged_in_admin
    ensure_logged_in
    redirect_to tasks_path unless admin?
  end
end
