# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails

  rescue_from Exception, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render 'errors/404.html', status: :not_found
  end

  def internal_server_error
    render 'errors/500.html', status: :internal_server_error
  end
end
