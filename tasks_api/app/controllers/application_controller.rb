# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Flash
  include HttpAcceptLanguage::AutoLocale

  rescue_from Exception, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :maintenance
  before_action :set_login_user

  private

  def not_found
    render json: { status: 404 }, status: :not_found
  end

  def internal_server_error
    render json: { status: 500 }, status: :internal_server_error
  end

  def maintenance
    if Maintenance.count.positive?
      render json: { status: 503, type: 'under_maintenance' }, status: :service_unavailable
      false
    else
      true
    end
  end

  def set_login_user
    @login_user = begin
      User.find(session[:login_user_id])
    rescue StandardError
      nil
    end
  end

  def sign_in_required
    if @login_user.blank?
      head :unauthorized
      return false
    end

    true
  end
end
