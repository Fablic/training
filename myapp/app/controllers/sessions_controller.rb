class SessionsController < ApplicationController

  def new
    session[:user_id] = nil
  end

  def create
    # binding.pry
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])

      # TODO: session につめる
      login(user)
      flash.now[:danger] = I18n.t('flash.session.login.success')
      return redirect_to tasks_path
    else
      flash.now[:danger] = I18n.t('flash.session.login.failure')
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    logout
    return redirect_to login_path
  end

  private

  def session_params
    params.require('session').permit(:email, :password)
  end
end
