class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid username or password'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to login_path, notice: 'Logged out successfully!'
  end
end
