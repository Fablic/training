class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = t('notice.invalid_email_or_password_combination')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/login'
  end
end
