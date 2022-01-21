# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_admin_role, only: %i[index show update destroy]
  before_action :authorize_user_role, only: [:my_profile]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  def my_profile
    render json: current_user
  end

  # POST /users
  def create
    @user = User.new(user_create_params)

    if @user.save
      render json: { user: @user, token: encode_token(@user) }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_update_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_create_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:role)
  end
end
