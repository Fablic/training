# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user_by_id, only: %i[show edit update destroy]
  skip_before_action :authenticate_user, only: [:new, :create]

  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    return unless @user.save

    flash[:success] = I18n.t 'users.flash.create.success'
    redirect_to @user
  end

  def edit
  end

  def update
    return unless @user.update(user_params)

    flash[:success] = I18n.t 'users.flash.update.success'
    redirect_to @user
  end

  def destroy
    @user.destroy

    flash[:success] = I18n.t 'users.flash.destroy.success'
    redirect_to new_user_url
  end

  private

  def set_user_by_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
