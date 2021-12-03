# frozen_string_literal: true

class ApplicationController < ActionController::Base

  rescue_from Exception,                      with: :render_server_error
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound,   with: :render_not_found

  protect_from_forgery with: :exception
  include SessionsHelper

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def logged_in_user
    return if logged_in?

    flash[:error] = t('sessions.flash.no_login')
    redirect_to login_url
  end

  private

  def render_not_found(exc = nil)
    logger.info "Rendering 404 with excaption: #{exc.message}" if exc
    render file: Rails.root.join('public/404_original.html'), status: :not_found, layout: 'application', content_type: 'text/html'
  end

  def render_server_error(exc = nil)
    logger.error "Rendering 500 with excaption: #{exc.message}" if exc
    render file: Rails.root.join('public/500_original.html'), status: :internal_server_error, layout: 'application', content_type: 'text/html'
  end
end
