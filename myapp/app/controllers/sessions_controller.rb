class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to tasks_path
    else
      flash.now[:notice] = 'Wrong username or password!'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
