module Admin
  class UsersController < ApplicationController
    before_action :logged_in_admin_user, only: %i[index new create edit update destroy]

    def index
      logged_in_admin_user
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, flash: { success: t('.flash_success') }
      else
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, flash: { success: t('.flash_success') }
      else
        render :edit
      end
    end

    def destroy
      user = User.find(params[:id])
      if user.destroy
        redirect_to admin_users_path, flash: { success: t('.flash_success') }
      else
        flash[:danger] = ''
        user.errors.full_messages.each do |message|
          flash[:danger] << message
        end
        redirect_to admin_users_path
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :admin_flg, :password)
    end
  end
end
