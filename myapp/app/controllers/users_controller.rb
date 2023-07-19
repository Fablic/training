# frozen_string_literal: true

# some comments here for user controller
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :user_tasks, only: [:show]

  def index
    @users = User.all
                 .page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_create_params)
    if @user.save
      redirect_to users_path, flash: { success: t('flash_msgs.user.create_ok') }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if username_not_duplicate?(user_update_params) && @user.update(user_update_params)
      redirect_to user_path(@user), flash: { success: t('flash_msgs.user.update_ok') }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, flash: { success: t('flash_msgs.user.delete_ok') }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_create_params
    params.require(:user).permit(:name, :password, :description, :role)
  end

  def user_update_params
    params.require(:user).permit(:name, :description, :role)
  end

  def username_not_duplicate?(params)
    username = params[:name]
    if username == @user.name || !User.find_by(name: username)
      return true
    end

    false
  end

  def user_tasks
    @tasks = Task.get_own_tasks(@user)
                 .sort_by_column('created_at', 'ASC')
                 .page(params[:page])
  end
end
