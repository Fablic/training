# frozen_string_literal: true

class Admin::UsersController < ApplicationController # rubocop:disable Style/ClassAndModuleChildren
  before_action :admin_user

  def index
    @users = User.all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render :new
    end
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
