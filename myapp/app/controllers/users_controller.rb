# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_user
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  USERS_PER_PAGE = 5
  def index
    @users = User.
             left_joins(:tasks).
             select("users.*", "COUNT(tasks.id) AS tasks_count").
             group("users.id")
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to users_path, notice: t("users.create.notice")
    else
      redirect_to new_user_path, alert: t("users.create.alert")
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: t("users.update.notice")
    else
      render :edit, alert: t("users.update.alert")
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: t("users.delete.notice")
    else
      redirect_to users_path, alert: t("users.delete.alert")
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
