# frozen_string_literal: true

# some comments for application controller
class ApplicationController < ActionController::Base
  include SessionsHelper
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

    redirect_to '/login', flash: { notice: t('flash_msgs.no_login') }
  end

  def admin_user?
    unless admin?
      redirect_to '/404'
    end
  end
end
