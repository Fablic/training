class SessionsController < ApplicationController
  skip_before_action :login_required

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, flash: { success: I18n.t('sessions.flash.login.success') }
    else
      flash.now[:danger] = I18n.t('あああ')
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url, flash: { success: I18n.t('sessions.flash.logout.success') }
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
