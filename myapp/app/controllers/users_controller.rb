class UsersController < ApplicationController
  before_action :require_login
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'users/edit'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'users/new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('.success')
    redirect_to action: 'index'
  rescue StandardError => e
    flash[:danger] = t('.danger')
    redirect_to action: 'index'
  end

  private

  def user_params
    params.require(:user).permit(:name, :personal_id, :password, :password_confirmation, :admin)
  end
end
