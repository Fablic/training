class SessionsController < ApplicationController

  def new; end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user.blank?
      flash.now[:danger] = t('sessions.flash.login.invalid_email')
      return render :new
    end

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

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
