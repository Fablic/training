# frozen_string_literal: true

class SessionsController < ApplicationController
  def login; end

  def auth
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user

      flash[:success] = I18n.t('auth.messages.login_success')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('auth.messages.login_fail')
      render :login
    end
  end

  def logout
    log_out if logged_in?

    flash[:success] = I18n.t('auth.messages.logout_success')
    redirect_to root_path
  end
end
