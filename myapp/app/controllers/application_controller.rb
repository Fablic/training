class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :re_sign_in

  def sign_in(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
    @current_user
  end

  def re_sign_in
    redirect_to(login_path) if current_user.nil?
  end
end
