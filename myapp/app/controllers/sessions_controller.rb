class SessionsController < ApplicationController
  before_action :logged_in_user, only: [:destroy]

  def new
    redirect_to root_path, notice: 'You are already logged in.' if user_logged_in?
  end

  # post method for login
  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      message = 'Something went wrong! Make sure email and password are correct'
      redirect_to login_path, notice: message
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
