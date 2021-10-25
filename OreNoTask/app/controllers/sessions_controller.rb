# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:notice] = I18n.t('dictionary.messages.failed_login')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
