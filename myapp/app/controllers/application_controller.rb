# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(e = nil)
    logger.info "Rendering 404 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render 'errors/404.html', status: :not_found
    end
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render 'errors/500.html', status: :internal_server_error
    end
  end

  # ログイン済みユーザーかどうか確認
  def check_login_status
    return if logged_in?

    redirect_to login_url
  end

  def check_user_role
    return if current_user.admin?

    flash[:danger] = I18n.t('auth.messages.admin_required')
    redirect_to root_path
  end
end
