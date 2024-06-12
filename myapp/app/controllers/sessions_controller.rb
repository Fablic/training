class SessionsController < ApplicationController
  def signup_new
    @user = User.new
    render 'signup_new'
  end

  def signup_create
    user_data = params.require(:user).permit(:username, :password, :password_confirmation)

    @user = User.new(user_data)

    if @user.save 
      log_in(@user)
      redirect_to tasks_path, notice: 'Successfully signed up!' 
    else 
      render :signup_new
    end
  end
  
  def new
    redirect_to tasks_path, notice: 'Already logged in!' if logged_in?
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to tasks_path
    else
      redirect_to login_path, notice: 'Wrong username or password!'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
