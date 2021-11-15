# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :maintenance_mode_switch
  before_action :logged_in_user
  rescue_from Exception,                      with: :render_server_error
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound,   with: :render_not_found

  include SessionsHelper

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render_not_found(exc = nil)
    logger.info "Rendering 404 with excaption: #{exc.message}" if exc
    render file: Rails.root.join('public/404.html'), status: :not_found, layout: 'application', content_type: 'text/html'
  end

  def render_server_error(exc = nil)
    logger.error "Rendering 500 with excaption: #{exc.message}" if exc
    render file: Rails.root.join('public/500.html'), status: :internal_server_error, layout: 'application', content_type: 'text/html'
  end

  def logged_in_user
    return if logged_in?

    redirect_to login_url
  end

  def maintenance_mode_switch
    return unless Maintenance.exists?
    return if Maintenance.first.maintenance_on_flag == false

    redirect_to maintenance_index_path
  end
end
