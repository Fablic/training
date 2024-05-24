# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: t("users.create.notice") # TODO: ユーザが作成されました
    else
      render :new, alert: t("users.create.alert") # TODO: ユーザが作成されませんでした。
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
