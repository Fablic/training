class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  before_action :check_maintenance

  rescue_from Exception,                      with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
  rescue_from ActionController::RoutingError, with: :_render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def login_required
    redirect_to login_url unless current_user
  end

  def current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def check_maintenance
    maintenance = Maintenance.find_by(content_id: TASK)
    render 'maintenance/maintenance.html' if maintenance.maintenance_flg
  end

  def _render_404(e = nil)
    logger.error "Rendering 404 with exception: #{e.message}" if e.present?
    render 'errors/404.html', status: :not_found
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e.present?
    render 'errors/500.html', status: :internal_server_error
  end
end
