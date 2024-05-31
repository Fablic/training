# frozen_string_literal: true

class SessionsController < ApplicationController
  protect_from_forgery

  def new
  end

  def create
    @user = User.authenticate(params[:session][:email], params[:session][:password])
    if @user
      session[:user_id] = @user.id
      if @user[:role] == "admin"
        redirect_to users_path
      else
        redirect_to tasks_path, notice: t("sessions.create.notice")
      end
    else
      redirect_to login_path, alert: t("sessions.create.alert")
    end
  end

  def destroy
    session.delete :user_id
    redirect_to tasks_path
  end
end
