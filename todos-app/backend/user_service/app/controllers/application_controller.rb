# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ArgumentError, with: :invalid_enum

  def invalid_enum(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  # 30 min expiration by default
  def encode_token(user, expire_after = 30 * 60)
    payload = {
      user_id: user.id,
      role: user.role,
      exp: Time.now.to_i + expire_after,
    }
    JWT.encode(payload, Rails.application.secrets.jwt_secret_key, 'HS256')
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

  def authorize_user_role
    render json: { error: 'Unauthorized' }, status: :unauthorized unless logged_in? && (decoded_payload['role'] == 'user' || decoded_payload['role'] == 'admin')
  end

  def authorize_admin_role
    render json: { error: 'Unauthorized' }, status: :unauthorized unless logged_in? && decoded_payload['role'] == 'admin'
  end
end
