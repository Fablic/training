class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new
  end

  def create
    user = User.find_by(email: user_login_params[:email].downcase)
    if user&.authenticate(user_login_params[:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:error] = "Invalid email/password combination"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private

  def user_login_params
    params.require(:session).permit(:email, :password)
  end
end
