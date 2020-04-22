class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :render_maintenance_page, if: :maintenance_mode?
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

  def maintenance_mode?
    File.exist?('tmp/maintenance.txt')
  end

  def render_maintenance_page
    render file: Rails.public_path.join('503.html'), layout: false, status: :service_unavailable
  end
end
