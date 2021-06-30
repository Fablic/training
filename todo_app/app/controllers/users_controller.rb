# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_param)
    if @user.save
      log_in @user
      flash[:success] = I18n.t(:'message.registered_task')
      redirect_to root_path
    else
      flash.now[:error] = I18n.t(:'message.registered_is_failed')
      render :new
    end

  end

  private

  def users_param
    params.require(:user).permit(:username, :email, :icon, :password, :password_confirmation)
  end
end
