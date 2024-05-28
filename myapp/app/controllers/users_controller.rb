# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: t("users.create.notice")
    else
      redirect_to signup_path, alert: t("users.create.alert")
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
