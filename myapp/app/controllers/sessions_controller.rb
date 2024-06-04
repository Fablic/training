class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to tasks_path
    else
      render :new 
    end
  end

  def destroy
  end
end
