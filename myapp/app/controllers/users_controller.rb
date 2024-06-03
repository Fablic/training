class UsersController < ApplicationController
  def signup
    @user = User.new
  end

  def signin
  end

  def signout
  end

  def create
    user_data = params.require(:user).permit(:username, :password, :password_confirmation)

    @user = User.new(user_data)

    if @user.save 
      redirect_to tasks_path, notice: 'Successfully signed up!' 
    else 
      render :signup
    end
  end
end
