class ApplicationController < ActionController::Base
  before_action :_render_503, if: :maintenance_mode?

  def maintenance_mode?
    File.exist?('tmp/maintenance.txt')
  end

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  include SessionsHelper

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'ログインしてください。'
    redirect_to login_url
  end

  private

  def _render_404(e = nil)
    logger.info "Rendering 404 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render 'errors/404.html', status: :not_found, layout: 'error'
    end
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render 'errors/500', status: :internal_server_error, layout: 'error'
    end
  end

  def _render_503
    if request.format.to_sym == :json
      render json: { error: '503 Service Unavailable' }, status: :service_unavailable
    else
      render 'errors/503', status: :service_unavailable, layout: 'error'
    end
  end
end
