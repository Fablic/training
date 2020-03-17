class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('flash.create.success')
      # TODO: ログイン画面実装後はそちらに遷移させる
      # redirect_to login_path
      render :new
    else
      flash.now[:danger] = t('flash.create.danger')
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
