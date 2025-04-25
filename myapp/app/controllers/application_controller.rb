class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :redirect_to_maintenance, except: [:maintenance]
  helper_method :current_user, :logged_in?
  
  private
  
  def set_locale
    locale = params[:locale] || session[:locale] || I18n.default_locale
    I18n.locale = locale
    session[:locale] = locale
  end
  
  def default_url_options
    { locale: I18n.locale }
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = I18n.t 'must_login'
      redirect_to login_path
    end
  end

  def redirect_to_maintenance
    if File.exist?(Rails.root.join('tmp', 'maintenance.txt'))
      redirect_to maintenance_path
    end
  end
end
  
