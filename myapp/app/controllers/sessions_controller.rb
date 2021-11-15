# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :logged_in_user
  # GET /login(.:format)
  def new
    redirect_to root_path if logged_in?
  end

  # POST /login(.:format)
  def create
    user = User.find_by(name: params[:session][:name])
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = 'login failed'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
