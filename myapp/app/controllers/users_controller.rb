require 'bcrypt'

class UsersController < ApplicationController
  before_action :redirect_to_root_path_if_logged_in

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)
    if @user.save
      flash[:success] = I18n.t 'msg_create_success'

      user = User.find_by(id: @user.id)
      log_in(user)

      redirect_to root_path
    else
      flash.now[:danger] = I18n.t 'msg_create_failure'

      @new_user = @user
      render :new, status: :unprocessable_entity
    end
  end

  # TODO: update password
  def update
  end

  private

  def create_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
