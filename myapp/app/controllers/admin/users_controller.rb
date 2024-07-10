# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController # rubocop:disable Style/Documentation
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.eager_load(:tasks).order(created_at: :asc)
    end

    def show
      # show
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(create_user_params)
      if @user.save
        redirect_to admin_user_path(@user), notice: I18n.t('admin.users.create_success')
      else
        render :new
      end
    end

    def edit
      # edit
    end

    def update
      return unless can_update_role?

      if @user.update(update_user_params)
        redirect_to admin_user_path(@user), I18n.t('admin.users.update_success')
      else
        render :edit
      end
    end

    def destroy
      return unless can_delete_user?

      return if @user.admin? && !can_delete_admin?

      delete_user
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def create_user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :status, :role)
    end

    def update_user_params
      params.require(:user).permit(:password, :password_confirmation, :status, :role)
    end

    def can_update_role?
      target_role = update_user_params[:role]
      admin_users = User.where(role: 'admin')
      if target_role == 'standard' && admin_users.count == 1 && admin_users[0].id == @user.id
        flash[:alert] = I18n.t('admin.users.only_one_admin')
        redirect_to admin_users_path
        return false
      end
      true
    end

    def can_delete_user?
      return true if @user.id != current_user.id

      flash[:alert] = I18n.t('admin.users.cannot_delete_own_account')
      redirect_to admin_users_path
      false
    end

    def can_delete_admin?
      users = User.where(role: 'admin')
      if users.count < 2
        flash[:alert] = I18n.t('admin.users.only_one_admin')
        redirect_to admin_users_path
        return false
      end
      true
    end

    def delete_user
      if @user.destroy
        flash[:notice] = I18n.t('admin.users.delete_success')
      else
        flash[:alert] = I18n.t('admin.users.delete_success')
      end
      redirect_to admin_users_path
    end
  end
end
