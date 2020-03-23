# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandle

  before_action :maintenance_page, if: :maintenance?
  before_action :verify_authenticity_token
  before_action :set_locale
  before_action :current_user
  before_action :require_sign_in!
  helper_method :signed_in?

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def signed_in?
    @current_user.present?
  end

  def sign_out
    @current_user = nil
    cookies.delete(:user_remember_token)
  end

  private

  def maintenance?
    data = open('config/maintenance.yml', 'r') { |f| YAML.load(f) }
    data["maintenance_mode"]
  end

  def maintenance_page
    render_503
  end

  def require_sign_in!
    redirect_to root_path unless signed_in?
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : :en
  end
end
