# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    render json: { session_user: @login_user ? @login_user.uid : 'guest' }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      head :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def login
    @user = User.where(uid: params[:uid]).first

    if @user&.validate_password(params[:password])
      session[:login_user_id] = @user.id
      head :ok
    else
      head :not_found
    end
  end

  def logout
    session[:login_user_id] = nil
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:uid, :password)
  end
end
