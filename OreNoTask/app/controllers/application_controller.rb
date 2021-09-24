# frozen_string_literal: true

class ApplicationController < ActionController::Base
  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(err = nil)
    logger.info "Rendering 404 with excaption: #{err.message}" if err

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render 'errors/404.html', status: :not_found, layout: 'error'
    end
  end

  def _render_500(err = nil)
    logger.error "Rendering 500 with excaption: #{err.message}" if err

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render 'errors/500.html', status: :internal_server_error, layout: 'error'
    end
  end
end
