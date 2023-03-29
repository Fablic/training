class ApplicationController < ActionController::Base
  private
  
  add_flash_types :success, :info, :warning, :danger
  rescue_from Exception, with: :render_500
  rescue_from ActionController::BadRequest, with: :render_400
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  helper_method :current_user
  before_action :login_required

  def render_400(e = nil)
    logger.error "Rendering 400 with excaption: #{e.message}" if e
    
    if request.format.to_sym == :json
      render json: { error: '400 Bad Request' }, status: :not_found
    else
      render file: 'public/400.html', status: 400, layout: false, content_type: 'text/html'
    end
  end

  def render_404(e = nil)
    logger.error "Rendering 404 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render file: 'public/404.html', status: 404, layout: false, content_type: 'text/html'
    end
  end

  def render_500(e = nil)
    logger.error "Rendering 500 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render file: 'public/404.html', status: 404, layout: false, content_type: 'text/html'
    end
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end

end
