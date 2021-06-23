class ApplicationController < ActionController::Base

  unless Rails.env.development?
    rescue_from StandardError, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render template: 'errors/not_found', status: :not_found
  end
      
  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e 

    render template: 'errors/internal_server_error', status: :internal_server_error
  end
end
