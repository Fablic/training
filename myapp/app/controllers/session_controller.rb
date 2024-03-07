class SessionController < ApplicationController

  skip_before_action :logged_in_user

  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password_digest])
      log_in user
      redirect_to root_url
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








