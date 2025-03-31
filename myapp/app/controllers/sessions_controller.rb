class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = I18n.t 'msg_login_success'
      redirect_to tasks_path
    else
      flash.now[:alert] = I18n.t 'msg_invalid_username_or_password'
      render :new, status: 422
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = I18n.t 'msg_logout'
    redirect_to login_path
  end
end
