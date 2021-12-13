# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('pages.session.flash.login_fail')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
