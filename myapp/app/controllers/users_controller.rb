require 'pp'

class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show]
  before_action :logged_in_as_admin, only: [:add, :index]
  # the new method will be used to present the form to create users

  def index
    @users = User.order('created_at desc').page(params[:page]).per(5)
  end

  # the new method will be used to present the form to create users
  def new
    if !user_logged_in?
      @user = User.new
    else
      redirect_to root_path
    end
  end

  # sign up
  def create
    @user = User.create(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      redirect_to signup_path
    end
  end

  def show_profile

  end

  def edit_profile

  end

  # admin functions
  def show
    @user = User.find(params[:id])
  end

  # add new users
  def add
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, flash: { success: 'Updated' }
    else
      flash.now[:danger] = 'Failed'
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, flash: { success: 'Deleted' }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :role)
  end
end
