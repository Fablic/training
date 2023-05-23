class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      login(user)
      redirect_to tasks_path, success: t('session.login.success')
    else
      flash.now[:danger] = t('session.login.failure')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path, success: t('session.logout.success')
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
