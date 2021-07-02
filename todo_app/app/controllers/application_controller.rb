# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
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

    render template: 'errors/not_found', status: :not_found
  end

  def render_internal_server_error(error = nil)
    logger.info "Rendering 500 with exception: #{error.message}" if error

    render template: 'errors/internal_server_error', status: :internal_server_error
  end

  def authenticate_user
    redirect_to login_path unless user_signed_in?
  end
end
