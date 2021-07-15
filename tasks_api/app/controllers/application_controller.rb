# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Flash
  include HttpAcceptLanguage::AutoLocale

  rescue_from Exception, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
  def not_found
    render json: { status: 404 }, status: :not_found
  end

  def internal_server_error
    render json: { status: 500 }, status: :internal_server_error
  end
end
