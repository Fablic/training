# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    def index
      @users = User.includes(:tasks).all
    end

    def new
      @user = User.new
    end

    def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully destroyed.'
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
