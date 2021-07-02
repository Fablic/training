# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create]

  def new
    redirect_to root_path if user_signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to root_path, flash: { success: I18n.t('users.flash.success.create') }
    else
      flash.now[:danger] = I18n.t('users.flash.error.create')
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
