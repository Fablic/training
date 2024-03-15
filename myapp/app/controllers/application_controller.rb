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

  private

  def logged_in_user
    return if logged_in?
    redirect_to '/login'
  end
end
