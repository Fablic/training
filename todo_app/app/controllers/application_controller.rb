# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authenticate_user

  unless Rails.env.development?
    rescue_from StandardError, with: :render500
    rescue_from ActionController::RoutingError, with: :render404
    rescue_from ActiveRecord::RecordNotFound, with: :render404
  end

  def render404(err = nil)
    logger.info "Rendering 404 with exception: #{err.message}" if err

    render file: Rails.root.join('public/404.html'), status: :not_found
  end

  def render500(err = nil)
    logger.info "Rendering 500 with exception: #{err.message}" if err

    render file: Rails.root.join('public/500.html'), status: :internal_server_error
  end

  def authenticate_user
    redirect_to login_path unless logged_in?
  end
end
