# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from Exceptions::InvalidSortParams, with: :bad_request
  rescue_from Exceptions::InvalidStatusParams, with: :bad_request
  rescue_from Exceptions::InvalidPaginationParams, with: :bad_request
  rescue_from Exceptions::InvalidLabelParams, with: :bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ArgumentError, with: :invalid_enum

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def unprocessable_entity(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def invalid_enum(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def decoded_payload
    if request.headers['Authorization']
      # {Authorization: Bearer <token>}
      token = request.headers['Authorization'].split.pop
      begin
        decoded = JWT.decode(token, Rails.application.secrets.jwt_secret_key, true, algorithm: 'HS256')
        # first element is the JWT payload, second element is the JWT header
        decoded.first
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in?
    !decoded_payload.nil?
  end

  def authorize
    render json: { error: 'Unauthorized' }, status: :unauthorized and return unless logged_in?

    @user_id = decoded_payload['user_id']
    return unless params[:user_id]

    # user_id param can only be used by admins
    if decoded_payload['role'] == 'admin'
      @user_id = params[:user_id]
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
