# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :admin_user
    before_action :find_by_id, only: [:show, :edit, :update]

    def index
      @users = User.all.order(created_at: :desc)
    end

    def show
      @tasks = Task.search(user_id: @user.id,
                           status: params[:status],
                           keyword: params[:keyword],
                           sort: params[:sort],
                           direction: params[:direction]).page(params[:page])
    end

    def new
      @user = User.new
    end

    def edit
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:success] = I18n.t('users.flash.create.success')
        redirect_to admin_users_path
      else
        flash.now[:danger] = I18n.t('users.flash.create.error')
        render :new
      end
    end

    def update
      if update_admin?(params)
        if @user.update(user_params)
          flash[:success] = I18n.t('users.flash.update.success')
          redirect_to admin_users_path
        else
          flash.now[:danger] = I18n.t('users.flash.update.error')
          render :new
        end
      else
        flash[:danger] = I18n.t('users.flash.update.error')
        redirect_to admin_users_path
      end
    end

    def destroy # rubocop:disable Metrics/AbcSize
      if login_user?
        flash[:danger] = I18n.t('users.flash.destroy.login_user')
      elsif destroy_admin?(params)
        if User.find(params[:id]).destroy
          flash[:success] = I18n.t('users.flash.destroy.success')
        else
          flash[:danger] = I18n.t('users.flash.destroy.error')
        end
      else
        flash[:danger] = I18n.t('users.flash.destroy.admin.error')
      end
      redirect_to admin_users_path
    end

    private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def find_by_id
      @user = User.find(params[:id])
    end

    def login_user?
      return true if params[:id].to_i == current_user.id

      false
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end

    def update_admin?(params)
      count_admin = User.where(admin: true).count

      if count_admin > 1 || User.find_by(admin: true).id != params[:id].to_i || params[:user][:admin] != 'member'
        return true
      end

      false
    end

    def destroy_admin?(params)
      count_admin = User.where(admin: true).count

      if count_admin > 1 || User.find_by(admin: true).id != params[:id].to_i
        return true
      end

      false
    end
  end
end
