# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
  end
end
