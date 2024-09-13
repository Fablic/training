require 'bcrypt'

class SessionsController < ApplicationController
  before_action :redirect_to_root_path_if_logged_in, only: [:new, :create]

  def new
  end

  def create
    @name = params[:session][:name]
    password = params[:session][:password]

    user = User.find_by(name: @name.downcase)
    if !user.nil? && user.authenticate(password)
      Rails.logger.info('login success')

      log_in(user)
      redirect_to root_path
      return
    end

    flash.now[:danger] = I18n.t 'session.login_failed'
    render :new, status: :unprocessable_entity
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end
end
