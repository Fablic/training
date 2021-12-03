# frozen_string_literal: true

class SessionsController < ApplicationController

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(login_id: params[:session][:login_id].downcase)

    if user && user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:error] = t('sessions.flash.invalid_login')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
