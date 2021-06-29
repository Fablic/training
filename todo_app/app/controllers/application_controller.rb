# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authenticate_user

  unless Rails.env.development?
    rescue_from StandardError, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render file: Rails.root.join('public/404.html'), status: 404
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e

    render file: Rails.root.join('public/500.html'), status: 500
  end

  def authenticate_user
    redirect_to login_path unless logged_in?
  end
end
