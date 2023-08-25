class AuthController < ApplicationController
  def login
    render 'login'
  end

  def authenticate
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user] = user
      flash[:success] = t('login.form.flashes.success.login')
      redirect_to tasks_path
    else
      flash[:failed] = t('login.form.flashes.failed.login')
      render :login
    end
  end

  def logout
    session[:user] = nil
    flash[:logout] = t('login.form.flashes.success.logout')
    redirect_to login_path
  end
end
