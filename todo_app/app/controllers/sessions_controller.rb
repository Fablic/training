class SessionsController < ApplicationController
  def new
  end

  def create
    session = params[:session]
    user = User.find_by(email: session[:email].downcase)
    if user&.authenticate(session[:password])
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
end
