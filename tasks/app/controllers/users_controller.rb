class UsersController < ApplicationController
  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    create_params = user_params.merge(role: User::GENERAL)
    @user = User.new(create_params)
    respond_to do |format|
      if @user.save
        log_in(@user)
        format.html { redirect_to root_path, notice: '新しいユーザーを登録しました。' }
        format.json { render root_path, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end
