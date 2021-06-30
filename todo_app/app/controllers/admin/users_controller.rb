# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    layout 'admin'

    before_action :find_admin_user, only: %i[edit update destroy]

    def index
      @admin_users = User.includes(:tasks).page(params[:page])
    end

    def new
      @admin_user = User.new
    end

    def edit; end

    def update
      if @admin_user.update(admin_user_params)
        redirect_to admin_users_path, flash: { success: I18n.t('users.flash.success.update') }
      else
        flash.now[:danger] = I18n.t('users.flash.error.update')
        render :edit
      end
    end

    def create
      @admin_user = User.new(admin_user_params)
      if @admin_user.save
        redirect_to admin_users_path, flash: { success: I18n.t('users.flash.success.create') }
      else
        flash.now[:danger] = I18n.t('users.flash.error.create')
        render :new
      end
    end

    def destroy
      @admin_user.destroy
      redirect_to admin_users_path, flash: { success: I18n.t('users.flash.success.destroy') }
    end

    private

    def admin_user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def find_admin_user
      @admin_user = User.find_by(id: params[:id])
    end
  end
end
