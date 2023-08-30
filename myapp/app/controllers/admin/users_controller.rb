class Admin::UsersController < ApplicationController
  before_action :check_admin_auth

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
      flash[:success] = t('user.flashes.success.created')
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = t('user.flashes.success.updated')
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.tasks.destroy_all
    @user.destroy
    flash[:success] = t('user.flashes.success.deleted')
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :username, :email, :password, :password_confirmation, :is_admin)
  end
end
