class ApplicationController < ActionController::Base
  before_action :render_maintenance, if: :maintenance_mode?
  around_action :switch_locale
  include SessionsHelper

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # see: https://guides.rubyonrails.org/i18n.html#setting-the-locale-from-url-params
  def default_url_options
    { locale: I18n.locale }
  end

  def render_404
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false, content_type: 'text/html'
  end

  def render_maintenance
    render file: Rails.public_path.join('503.html'), status: :service_unavailable, layout: false, content_type: 'text/html'
  end

  private

  def maintenance_mode?
    File.exist?('tmp/maintenance.txt')
  end
end
