# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to "/login" unless current_user
  end

  def require_admin_user
    # puts "XXXXXXXXXXXXXXXXXX"
    # puts current_user
    # puts "XXXXXXXXXXXXXXXXXX"
    redirect_to "/login", alert: t('errors.need_admin') unless current_user[:role] == 'admin'
  end

  # 例外処理
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from Exception, with: :render_500

  def render_404
    render template: "errors/error_404", status: 404, layout: "application", content_type: "text/html"
  end

  def render_500
    render template: "errors/error_500", status: 500, layout: "application", content_type: "text/html"
  end
end
