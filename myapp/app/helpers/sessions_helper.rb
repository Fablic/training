# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||=
      if session[:user_id]
        User.find_by(id: session[:user_id])
      end
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil # rubocop:disable Rails/HelperInstanceVariable
  end
end
