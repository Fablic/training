# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :forbid_access_except_admin
    before_action :find_user, only: %i[edit update destroy tasks]

    def index
      @users = User.search(params).page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_url, flash: { success: create_flash_message('create', 'success', @user, :email) }
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_url, flash: { success: create_flash_message('update', 'success', @user, :email) }
      else
        render :edit
      end
    end

    def destroy
      if @user == current_user
        flash[:danger] = I18n.t('flash.user_self_destroy')
      elsif @user.destroy
        flash[:success] = create_flash_message('destroy', 'success', @user, :email)
      else
        flash[:danger] = create_flash_message('destroy', 'failed', @user, :email)
      end

      redirect_to admin_users_url
    end

    def tasks
      @tasks = Task.search(params, @user.tasks).page(params[:page])
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

    def find_user
      @user = User.find(params[:id])
    end
  end
end
