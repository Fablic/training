# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :maintenance_switch, only: %i[new create destroy maintenance]
  skip_before_action :authorized, only: %i[new create destroy]
  layout false, only: %i[new create]
  def create
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new, locals: { alert: t('messages.invalid_login') }
    end
  end

  def new
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  def maintenance
    redirect_to root_path if Maintenance.count.zero?
  end
end
