class ApplicationController < ActionController::Base
  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def render_404
    render 'errors/404', status: 404
  end

  def render_500
    render 'errors/500', status: 500
  end
end
