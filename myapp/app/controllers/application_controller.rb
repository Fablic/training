class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :render503, if: :maintenance_mode?

  def maintenance_mode?
    File.exist?(Constants::MAINTENANCE_FILE_PATH)
  end

  def render503
    render(
      file: Rails.public_path.join('503.html'),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable
    )
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_log_in
    redirect_to login_path unless current_user
  end
end
