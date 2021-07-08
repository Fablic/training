# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper

  before_action :render_service_unavailable, if: :maintenance?
  before_action :authenticate_user

  unless Rails.env.development?
    rescue_from StandardError, with: :render_internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def render_not_found(error = nil)
    logger.info "Rendering 500 with exception: #{error.message}" if error

    render template: 'errors/not_found', layout: 'application', status: :not_found
  end

  def render_internal_server_error(error = nil)
    logger.info "Rendering 500 with exception: #{error.message}" if error

    render template: 'errors/internal_server_error', layout: 'application', status: :internal_server_error
  end

  def authenticate_user
    redirect_to login_path unless user_signed_in?
  end

  def render_service_unavailable
    render all_maintenance? ? 'layouts/maintenance' : "#{request_path[:controller]}/maintenance", status: :service_unavailable
  end
end
