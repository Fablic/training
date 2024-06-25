# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login, except: :login_actions
  helper_method :current_user

  private

  def require_login
    return if controller_name == 'sessions' && %w[new create].include?(action_name)

    return if current_user

    redirect_to login_url, alert: t('alerts.login_required')
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_admin
    return if current_user&.admin?

    flash[:alert] = '管理者権限が必要です。'
    redirect_to root_path
  end
end
