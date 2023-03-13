class SessionController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])

      # TODO: session につめる

      flash.now[:danger] = I18n.t('flash.session.login.success')
      return redirect_to tasks_path
    else
      flash.now[:danger] = I18n.t('flash.session.login.failure')
      render 'new', status: :unprocessable_entity
    end
  end

  def delete

  end

  private

  def session_params
    params.require('session').permit(:email, :password)
  end
end
