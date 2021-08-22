# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:success] = I18n.t('sessions.flash.create.success')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('sessions.flash.create.danger')
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
