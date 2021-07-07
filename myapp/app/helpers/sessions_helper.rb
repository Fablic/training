# frozen_string_literal: true

require 'pp'
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def admin_user
    @admin_user ||= current_user if current_user && current_user.role === 1
  end

  def admin_logged_in?
    !admin_user.nil?
  end

  def user_logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end
end
