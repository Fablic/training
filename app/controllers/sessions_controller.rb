# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:success] = I18n.t('sessions.flash.create.success')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('sessions.flash.create.failure')
      render :new
    end
  end

  def destroy
    reset_session
    flash[:success] = I18n.t('sessions.flash.destroy.success')
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
