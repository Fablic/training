# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :render_503, if: :maintenance_mode?

  add_flash_types :success, :info, :warning, :danger
  rescue_from Exception, with: :render_500
  rescue_from ActionController::BadRequest, with: :render_400
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  helper_method :current_user

  before_action :login_required

  def render_400
    render file: 'public/400.html', layout: false, status: 400
  end

  def render_404
    render file: 'public/404.html', layout: false, status: 404
  end

  def render_500
    render file: 'public/500.html', layout: false, status: 500
  end

  def render_503
    render file: 'public/503.html', layout: false, status: 503
  end

  private

  def maintenance_mode?
    File.exist?('/myapp/tmp/maintenance.txt')
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end
end
