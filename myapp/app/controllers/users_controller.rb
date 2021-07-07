class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show]
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

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :role, :name)
  end
end
