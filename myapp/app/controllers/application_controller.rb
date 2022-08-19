class ApplicationController < ActionController::Base
  rescue_from Exception,                      with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
  rescue_from ActionController::RoutingError, with: :_render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

    def _render_404(e = nil)
      logger.info "Rendering 404 with excaption: #{e.message}" if e
      render 'errors/404.html', status: :not_found
    end

    def _render_500(e = nil)
      logger.error "Rendering 500 with excaption: #{e.message}" if e
      render 'errors/500.html', status: :internal_server_error
    end
end
