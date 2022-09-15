class SessionsController < ApplicationController
  skip_before_action :login_user, only: [:new, :create]
  skip_before_action :re_login, only: [:new, :create]

  def new
  end

  def create
    # User取得
    @user = User.find_by(email: session_params[:email])
    if @user.nil? || !@user.authenticate(session_params[:password])
      flash.now[:alert] = I18n.t('message.login_failed')
      render(:new)
    else
      login(@user)
      redirect_to(root_path)
    end
  end

  def destroy
    logout
    redirect_to(login_path)
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
