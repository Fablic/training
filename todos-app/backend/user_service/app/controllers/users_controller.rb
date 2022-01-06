# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_admin_role, only: %i[index show update destroy]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users, only: %i[id email username role]
  end

  # GET /users/1
  def show
    render json: @user, only: %i[id email username role]
  end

  # POST /users
  def create
    @user = User.new(user_create_params)

    if @user.save
      render json: { user: @user, only: %i[email username role], token: encode_token(@user) }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_update_params)
      render json: @user, only: %i[email username role]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @user.role == 'admin'
      render json: { error: 'Admin cannot be deleted' }, status: :forbidden
    else
      @user.destroy
    end
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
