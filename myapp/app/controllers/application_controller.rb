class ApplicationController < ActionController::Base

  include SessionHelper
  
  before_action :logged_in_user
  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end


  def default_url_options
    { locale: I18n.locale }
  end

  def maintenance_mode?
    File.exist?('tmp/maintenance.txt')
  end

  def render_maintenance_page
    render(
      file: Rails.public_path.join('503.html'),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable,
    )
  end

  private

  def logged_in_user
    return if logged_in?
    redirect_to '/login'
  end
end
