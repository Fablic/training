# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.authenticate(params[:session][:email], params[:session][:password])
    if @user
      session[:user_id] = @user.id
      if @user[:role] == 'admin'
        redirect_to users_path
      else
        redirect_to tasks_path
      end
    else
      redirect_to login_path
    end
  end

  def destroy
    session.delete :user_id
    redirect_to tasks_path
  end
end
