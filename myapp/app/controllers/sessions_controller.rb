# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])

    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: (t 'users.flash.create.notice')
    else
      flash.now[:notice] = (t 'users.flash.notice')
      redirect_to login_form_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_form_path, notice: (t 'users.flash.destroy.notice')
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
