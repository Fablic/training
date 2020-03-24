class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_authenticate

  def check_authenticate
    if current_user.nil?
      session.clear
      redirect_to(sign_in_path)
    end
  end

  def current_user
    return if session[:user_id].nil?
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
