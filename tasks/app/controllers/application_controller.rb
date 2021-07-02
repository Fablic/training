class ApplicationController < ActionController::Base
  rescue_from Exception,                      with: :render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render_404(error = nil)
    logger.info "Rendering 404 with excaption: #{error.message}" if error

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render file: Rails.root.join('public/404.html'), status: :not_found, layout: false, content_type: 'text/html'
    end
  end

  def render_500(error = nil)
    logger.error "Rendering 500 with excaption: #{error.message}" if error

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render file: Rails.root.join('public/500.html'), status: :internal_server_error, layout: false, content_type: 'text/html'
    end
  end
end
