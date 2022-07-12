# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

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
end
