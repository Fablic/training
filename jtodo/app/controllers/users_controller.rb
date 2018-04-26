class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Success'
      redirect_to login_path
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
