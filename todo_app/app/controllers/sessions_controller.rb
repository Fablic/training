# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new
  end

  def create
    user = User.find_by(email: user_login_param[:email].downcase)
    if user&.authenticate(user_login_param[:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:error] = I18n.t(:'message.login_is_failed')
      render :new
    end
  end

  def destroy
    log_out
    @current_user = nil
    redirect_to login_path
  end

  private

  def user_login_param
    params.require(:session).permit(:email, :password)
  end
end
