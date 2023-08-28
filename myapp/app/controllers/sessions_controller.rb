class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: t('sessions.create.success')
    else
      flash.now[:alert] = t('sessions.create.failure')
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: t('sessions.destroy.success')
  end
end
