class ApplicationController < ActionController::Base
  rescue_from Exception,                      with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
  rescue_from ActionController::RoutingError, with: :_render_404

  helper_method :current_user
  before_action :login_required

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

    def _render_404(e = nil)
      logger.error "Rendering 404 with excaption: #{e.message}" if e.present?
      render 'errors/404.html', status: :not_found
    end

    def _render_500(e = nil)
      logger.error "Rendering 500 with excaption: #{e.message}" if e.present?
      render 'errors/500.html', status: :internal_server_error
    end

    def login_required
      redirect_to login_url unless current_user
    end

    def current_user
      @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    end
end
