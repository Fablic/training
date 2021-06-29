# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authencate_user, only: %i[new create]

  def new
    redirect_to root_path if user_signed_in?
  end

  def create
    @user = User.find_by(email: user_params[:email].downcase)
    if @user&.authenticate(user_params[:password])
      log_in(@user)
      flash[:success] = I18n.t('sessions.flash.success.create')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('sessions.flash.error.create')
      render :new
    end
  end

  def destroy
    log_out
    @current_user = nil
    redirect_to login_path, flash: { success: I18n.t('sessions.flash.success.destroy') }
  end

  private

  def user_params
    params.require(:session).permit(:email, :password)
  end
end
