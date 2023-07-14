# frozen_string_literal: true

# some comments for sessions controller
class SessionsController < ApplicationController
  skip_before_action :logged_in_user

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
