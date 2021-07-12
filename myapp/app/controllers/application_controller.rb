# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include UsersHelper
  include TasksHelper
  before_action :maintenance_mode_on!
  before_action :logged_in_user

  rescue_from StandardError, with: :render500
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def render404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.message}" if exception
    render 'errors/404', status: :not_found
  end

  def render500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render 'errors/500', status: :internal_server_error
  end

  private

  def logged_in_user
    return if user_logged_in? && current_user

    flash[:danger] = 'Please log in.'
    message = 'Please log in.'
    redirect_to login_path, notice: message
  end

  def logged_in_as_admin
    return if admin_logged_in?

    flash[:danger] = 'Please log in as admin.'
    message = 'Please log in as admin'
    redirect_to root_path, notice: message
  end

  def maintenance_mode_on!
    maintenance_flg = Maintenance.find(1)
    if maintenance_flg.status == 1
      redirect_to maintenance_index_path
    end
  end
end
