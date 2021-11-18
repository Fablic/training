# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    current_user.privilege == 1
  end

  def log_out
    session.delete(:user_id)
  end
end
