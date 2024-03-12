class SessionController < ApplicationController

  skip_before_action :logged_in_user

  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to tasks_path
    else
      flash.now[:notice] = t('flash_msgs.login_failed')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/login'
  end

  private

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end








