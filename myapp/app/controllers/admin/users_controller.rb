# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :ensure_an_admin_remains, only: %i[update destroy]

    def set_user
      @user = User.find(params[:id])
    end

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
      if @user.destroy
        redirect_to admin_users_url, notice: t('notices.user_deleted')
      else
        redirect_to admin_users_url, alert: t('alerts.user_not_deleted')
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_url, notice: t('notices.user_updated')
      else
        render :edit, alert: t('alerts.user_update_failed')
      end
    end

    private

    def ensure_an_admin_remains
      return unless User.where(admin: true).count <= 1 && @user.admin?

      redirect_to admin_users_url, alert: t('alerts.last_admin_cannot_be_deleted')
      nil
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end
  end
end
