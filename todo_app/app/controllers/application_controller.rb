# frozen_string_literal: true

class ApplicationController < ActionController::Base

  unless Rails.env.development?
    rescue_from StandardError, with: :render_internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_not_found(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render template: 'errors/not_found', status: :not_found
  end

  def render_internal_server_error(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e 

    render template: 'errors/internal_server_error', status: :internal_server_error
  end
end
