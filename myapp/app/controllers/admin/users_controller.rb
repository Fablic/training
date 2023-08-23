class Admin::UsersController < ApplicationController
  before_action :find_user, only: [:update, :show, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User created successfully."
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User updated successfully."
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @tasks = @user.tasks
  end

  def destroy
    @user.tasks.destroy_all
    @user.destroy
    redirect_to admin_users_path, notice: 'User and associated tasks deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
