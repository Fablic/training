# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login, except: :login_actions

  private

  def require_login
    return if controller_name == 'sessions' && %w[new create].include?(action_name)

    return if logged_in?

    redirect_to login_url, alert: 'ログインしてください。'
  end

  def logged_in?
    session[:user_id].present?
  end
end
