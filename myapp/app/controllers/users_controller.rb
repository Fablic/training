class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = I18n.t 'msg_account_create_success'
      redirect_to tasks_path
    else
      flash.now[:alert] = I18n.t 'msg_account_create_failure'
      render :new, status: 422
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password)
  end
end
