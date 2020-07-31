# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_maintenance

  unless Rails.configuration._use_original_error_screen_
    rescue_from StandardError, with: :rescue500
    rescue_from ActionController::RoutingError, with: :rescue404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
    rescue_from IllegalAccessError, with: :rescue403
    rescue_from MaintenanceError, with: :rescue503

    def routing_error(exception = nil)
      raise exception if exception
      raise ActionController::RoutingError, params[:path]
    end

    private

    def rescue500(exception = nil)
      logger.error "Rendering 500 with exception: #{exception.message}" if exception
      render 'errors/internal_server_error', status: 500
    end

    def rescue404(exception = nil)
      logger.info "Rendering 404 with exception: #{exception.message}" if exception
      render 'errors/not_found', status: 404
    end

    def rescue403(exception = nil)
      logger.info "Rendering 403 with exception: #{exception.message}" if exception
      render 'errors/forbidden', status: 403
    end

    def rescue503(exception = nil)
      logger.info "Rendering 503 with exception: #{exception.message}" if exception
      render 'errors/maintenance', status: 503
    end
  end

  private

  def current_user
    @current_user ||= AppUser.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end

  def check_maintenance
    @maintenance = Maintenance.find_maintenance
    raise MaintenanceError, @maintenance.reason if @maintenance.present?
  end

  helper_method :current_user
end
