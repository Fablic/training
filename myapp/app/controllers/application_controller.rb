# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :render_503_page, if: :maintenance_mode?
  before_action :login_required

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end

  def maintenance_mode?
    File.exist?(Constants::MAINTENANCE_FILE_PATH)
  end

  def render_503_page
    render file: Rails.root.join('public/503.html'), status: :service_unavailable, layout: false
  end
end
