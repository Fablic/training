# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include SessionsHelper

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  # unless Rails.env.production?
  #   rescue_from Exception,                        with: :_render500
  #   rescue_from ActiveRecord::RecordNotFound,     with: :_render404
  #   rescue_from ActionController::RoutingError,   with: :_render404
  # end

  private

  def _render404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 error' }, status: :not_found
    else
      render 'errors/404', status: :not_found
    end
  end

  def _render500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 error' }, status: :internal_server_error
    else
      render 'errors/500', status: :internal_server_error
    end
  end
end
