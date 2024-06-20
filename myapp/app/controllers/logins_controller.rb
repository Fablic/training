class LoginsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :require_login, only: %i[logout]

  def top; end

  def login
    user = User.find_by(username: login_params[:username])
    if user&.authenticate(login_params[:password])
      session[:user_id] = user.id
      @current_user = user
      redirect_to tasks_path, notice: I18n.t('views.common.welcome', username: user.username)
    else
      flash.now[:alert] = I18n.t('flash.common.failure', model: I18n.t('views.common.login'))
      render :top, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
    redirect_to login_path
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
