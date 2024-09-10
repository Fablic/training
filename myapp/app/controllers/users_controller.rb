require 'bcrypt'

class UsersController < ApplicationController
  before_action :redirect_to_root_path_if_logged_in

  def new
    @user = User.new
  end

  # TODO:
  # - add password confirmation
  # - implement password rule like minimum:8, mix alphabet, digit and special chars
  def create
    data = {
      name: params[:user][:name],
      password: params[:user][:password],
    }
    @user = User.new(data)
    if @user.save
      flash[:success] = I18n.t 'msg_create_success'

      user = User.find_by(name: data[:name])
      log_in(user)

      redirect_to root_path
    else
      flash.now[:danger] = I18n.t 'msg_create_failure'

      @new_user = @user
      render :new, status: :unprocessable_entity
    end
  end

  # update password
  def update
  end
end
