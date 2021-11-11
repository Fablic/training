# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :maintenance_switch
  before_action :authorized
  around_action :switch_locale
  helper_method :current_user
  helper_method :logged_in?
  helper_method :admin?
  around_action :skip_bullet, only: %i[destroy], if: -> { defined?(Bullet) }

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to '/login' unless logged_in?
  end

  def admin?
    current_user.admin
  end

  def maintenance_switch
    return if Maintenance.count.zero?

    redirect_to maintenance_path if logged_in? && !admin?
  end

  def skip_bullet
    previous_value = Bullet.enable?
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = previous_value
  end
end
