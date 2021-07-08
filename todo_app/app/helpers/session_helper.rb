# frozen_string_literal: true

module SessionHelper
  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def logged_in?
    current_user.present?
  end
end
