class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t('.success')
      redirect_to root_url
    else
      flash[:danger] = t('.failed')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t('.success')
    redirect_to root_url
  end
end
