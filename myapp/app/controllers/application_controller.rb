class ApplicationController < ActionController::Base
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
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end
end
