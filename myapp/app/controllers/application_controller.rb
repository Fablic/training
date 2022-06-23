# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # error handle
  rescue_from Exception, with: :_render_500
  rescue_from ActiveRecord::RecordNotFound, with: :_render_404
  rescue_from ActionController::RoutingError, with: :_render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(error = nil)
    logger.info "Rendering 404 with excaption: #{error.message}" if error
    render 'errors/404.html', status: :not_found
  end

  def _render_500(error = nil)
    logger.info "Rendering 500 with exception: #{error.message}" if error
    render 'errors/500.html', status: :internal_server_error
  end
end
