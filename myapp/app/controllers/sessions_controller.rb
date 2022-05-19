class SessionsController < ApplicationController
  skip_before_action :require_log_in, only: [:new, :create]
  before_action :verify_email, only: [:create]

  def new; end

  def create
    if @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:danger] = t('sessions.flash.login.invalid_password')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end

  private

  def verify_email
    @user = User.find_by!(email: session_params[:email])
  rescue StandardError
    flash.now[:danger] = t('sessions.flash.login.invalid_email')
    render :new
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
