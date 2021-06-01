class ApplicationController < ActionController::Base
  include SessionHandling

  around_action :switch_locale
  before_action :require_login

  private

  def switch_locale(&action)
    locale = params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)
    I18n.with_locale(locale, &action)
  end
end
