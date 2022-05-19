class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :require_log_in

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_log_in
    redirect_to login_path unless @current_user.present?
  end
end
