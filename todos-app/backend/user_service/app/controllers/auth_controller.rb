# frozen_string_literal: true

class AuthController < ApplicationController
  def login
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      token = encode_token(user)
      render json: { token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def logged_in_user
    render json: current_user
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password)
  end
end
