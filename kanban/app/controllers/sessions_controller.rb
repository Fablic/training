class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      log_in user
      redirect_to tasks_path
    else
      flash.now[:danger] = I18n.t('notice.session.authorize.fail')
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
