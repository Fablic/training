class ApplicationController < ActionController::Base

  rescue_from Exception,                      with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
  rescue_from ActionController::RoutingError, with: :_render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(e = nil)
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def _render_500(e = nil)
    format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :internal_server_error }
    format.xml  { head :internal_server_error }
    format.any  { head :internal_server_error }
  end
end
