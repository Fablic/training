class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:signup_new, :new]
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
