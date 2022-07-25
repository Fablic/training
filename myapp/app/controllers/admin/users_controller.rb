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
      redirect_to admin_users_path, { flash: { danger: I18n.t('users.flash.update.error') } } unless update_admin?(params)
    end

    def destroy
      if login_user?
        flash[:danger] = I18n.t('users.flash.destroy.login_user')
      else
        redirect_to admin_users_path, { flash: { danger: I18n.t('users.flash.destroy.admin.error') } } unless destroy_admin?(params)
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

    def update_admin?(params) # rubocop:disable Metrics/AbcSize
      count_admin = User.where(admin: true).count

      # 以下のユーザー情報を更新することができる
      # adminユーザーが2人以上の場合
      # adminユーザーが1人の時で、adminユーザー以外の情報を更新する場合
      # adminユーザーが1人の時で、adminユーザーがロール以外を更新する場合
      if count_admin > 1 || User.find_by(admin: true).id != params[:id].to_i || params[:user][:admin] != 'member'
        if @user.update(user_params)
          flash[:success] = I18n.t('users.flash.update.success')
          redirect_to admin_users_path
        else
          flash.now[:danger] = I18n.t('users.flash.update.error')
          render :new
        end
        return true
      end

      false
    end

    def destroy_admin?(params)
      count_admin = User.where(admin: true).count

      if count_admin > 1 || User.find_by(admin: true).id != params[:id].to_i
        if User.find(params[:id]).destroy
          flash[:success] = I18n.t('users.flash.destroy.success')
        else
          flash[:danger] = I18n.t('users.flash.destroy.error')
        end

        return true
      end

      false
    end
  end
end
