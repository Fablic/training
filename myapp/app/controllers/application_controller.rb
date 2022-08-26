class ApplicationController < ActionController::Base

  rescue_from Exception,                      with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
  rescue_from ActionController::RoutingError, with: :_render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(e = nil)
      render :file => "#{Rails.root}/public/404", status: :not_found, :layout => false
  end

  def _render_500(e = nil)
    render :file => "#{Rails.root}/public/500", status: :internal_server_error,  :layout => false
  end
end
