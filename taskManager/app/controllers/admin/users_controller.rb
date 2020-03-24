module Admin
  class UsersController < ApplicationController
    before_action :set_admin_user, only: %i[show edit update destroy]
    before_action -> { redirect_to sign_in_path }, unless: -> { current_user.present? }
    before_action -> { redirect_to tasks_path }, unless: -> { current_user.admin? }

    def index
      @admin_users = Admin::User
        .eager_load(:tasks)
        .all
    end

    def show
    end

    def new
      @admin_user = Admin::User.new
    end

    def edit
    end

    def create
      @admin_user = Admin::User.new(admin_user_params)
      if @admin_user.save
        flash[:success] = t('flash.create.success')
        redirect_to @admin_user
      else
        flash.now[:danger] = t('flash.create.danger')
        render :new
      end
    end

    def update
      if @admin_user.update(admin_user_params)
        flash[:success] = t('flash.update.success')
        redirect_to @admin_user
      else
        flash.now[:danger] = t('flash.update.danger')
        render :edit
      end
    end

    def destroy
      if @admin_user.destroy
        flash[:success] = t('flash.remove.success')
      else
        flash[:danger] = t('flash.remove.danger')
      end
      redirect_to admin_users_url
    end

    private

    def set_admin_user
      @admin_user = Admin::User.find(params[:id])
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :role)
    end
  end
end
