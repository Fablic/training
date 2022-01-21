# frozen_string_literal: true

class AuthController < ApplicationController
  def login
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      token = encode_token(user)
      render json: { user: user.as_json(only: %i[email username role]), token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def logged_in_user
    if logged_in?
      render json: User.find(decoded_payload['user_id']), only: %i[email username role]
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password)
  end
end
