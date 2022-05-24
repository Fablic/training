module Admin
  class UsersController < ApplicationController
    before_action :require_log_in
    before_action :require_admin_role
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.all_sort_by(:created_at, :desc)
    end

    def new
      @user = User.new
    end

    def show; end

    def edit; end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path, notice: t('admin.users.flash.success.create')
      else
        redirect_to new_admin_user_path, notice: t('admin.users.flash.failure.create')
      end
    end

    def update
      if update?(@user)
        if @user.update(user_params)
          redirect_to admin_users_path, notice: t('admin.users.flash.success.update')
        else
          redirect_to edit_admin_user_path(@user), notice: t('admin.users.flash.failure.update')
        end
      else
        redirect_to edit_admin_user_path(@user), notice: t('admin.users.flash.failure.update')
      end
    end

    def destroy
      if delete?(@user)
        @user.destroy
        flash[:notice] = t('admin.users.flash.success.destroy')
      else
        flash[:notice] = t('admin.users.flash.failure.destroy')
      end

      redirect_to admin_users_path
    end

    private

    def require_admin_role
      redirect_to(login_path) unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def update?(user)
      !keep_minimum_admin_count?(user) && user_params[:admin].eql?('false') ? false : true
    end

    def delete?(user)
      keep_minimum_admin_count?(user)
    end

    def keep_minimum_admin_count?(user)
      (current_user == user) && (User.where(admin: true).count) == User::MINIMUN_ADMIN_USER_COUNT ? false : true
    end
  end
end
