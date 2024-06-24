# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login, except: [:login_actions, :signup_actions]
  helper_method :current_user

  private

  def require_login
    return if controller_name == 'sessions' && %w[new create].include?(action_name)
    return if controller_name == 'users' && %w[new create].include?(action_name)

    return if logged_in?

    redirect_to login_url, alert: 'ログインしてください。'
  end

  def logged_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
