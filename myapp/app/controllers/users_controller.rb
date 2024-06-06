class UsersController < ApplicationController
  def new
    redirect_to tasks_path, notice: 'Already logged in!' if logged_in?
    @user = User.new
  end

  def create
    user_data = params.require(:user).permit(:username, :password, :password_confirmation)

    @user = User.new(user_data)

    if @user.save 
      log_in(@user)
      redirect_to tasks_path, notice: 'Successfully signed up!' 
    else 
      render :new
    end
  end
end
