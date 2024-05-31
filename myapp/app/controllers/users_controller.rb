# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_admin_user, only: [:index, :new, :show, :edit, :update, :create, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
      redirect_to users_path, notice: t("users.create.notice")
    else
      redirect_to new_user_path, alert: t("users.create.alert")
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: t("users.update.notice")
    else
      flash.now[:alert] = t("users.update.alert")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      if @user.id == session[:user_id]
        session.delete :user_id
      end
      redirect_to users_path, notice: t("users.delete.notice")
    else
      redirect_to users_path, alert: t("users.delete.alert")
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :role)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
