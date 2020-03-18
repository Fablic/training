class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_authenticate

  def check_authenticate
    redirect_to(sign_in_path) if current_user.nil?
  end

  def current_user
    return if session[:user_id].nil?
    @current_user ||= User.find(session[:user_id])
  end
  helper_method :current_user
end
