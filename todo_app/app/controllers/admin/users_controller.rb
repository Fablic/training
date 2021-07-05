# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    layout 'admin'

    before_action :find_admin_user, only: %i[edit update destroy tasks]
    before_action :ensure_destroy_user, only: %i[destroy]

    def index
      @users = User.includes(:tasks).page(params[:page])
    end

    def new
      @user = User.new
    end

    def edit; end

    def update
      if @user.update(admin_user_params)
        redirect_to admin_users_path, flash: { success: I18n.t('users.flash.success.update') }
      else
        flash.now[:danger] = I18n.t('users.flash.error.update')
        render :edit
      end
    end

    def create
      @user = User.new(admin_user_params)
      if @user.save
        redirect_to admin_users_path, flash: { success: I18n.t('users.flash.success.create') }
      else
        flash.now[:danger] = I18n.t('users.flash.error.create')
        render :new
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, flash: { success: I18n.t('users.flash.success.destroy') }
    end

    def tasks
      @tasks = @user.tasks.page(params[:page])
    end

    private

    def admin_user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def find_admin_user
      @user = User.find_by(id: params[:id])
    end

    def ensure_destroy_user
      flash.now[:danger] = I18n.t('users.flash.error.destroy')
      render :index and return if current_user.eql?(@user)
    end
  end
end
