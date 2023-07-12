# frozen_string_literal: true

# some comments for sessions controller
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash['notice'] = t('flash_msgs.login_failed')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/login'
  end

  private

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
