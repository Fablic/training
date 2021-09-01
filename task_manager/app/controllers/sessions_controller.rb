class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create]

  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = I18n.t 'sessions.flash.create.success'
      redirect_to user
    else
      flash[:danger] = I18n.t 'sessions.flash.create.danger'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:danger] = I18n.t 'sessions.flash.destroy.success'
    redirect_to login_url
  end
end
