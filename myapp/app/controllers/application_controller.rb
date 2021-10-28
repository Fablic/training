class ApplicationController < ActionController::Base
  include SessionsHelper
  include ApplicationHelper

  rescue_from Exception,                      with: :_render_internal_server_error
  rescue_from ActiveRecord::RecordNotFound,   with: :_render_not_found
  rescue_from ActionController::RoutingError, with: :_render_not_found

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = I18n.t('pages.sessions.flash.loginerror')
    redirect_to login_url
  end

  private

  def _render_not_found
    if request.format.to_sym == :json
      render json: { error: '404 Not Found' }, status: :not_found
    else
      render file: Rails.root.join('public/404.html'), status: :not_found, layout: false
    end
  end

  def _render_internal_server_error
    if request.format.to_sym == :json
      render json: { error: '500 Internal Server Error' }, status: :internal_server_error
    else
      render file: Rails.root.join('public/500.html'), status: :internal_server_error, layout: false
    end
  end
end
