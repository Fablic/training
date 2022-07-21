# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :admin_user

    def index
      @users = User.all.order(created_at: :desc)
    end

    def show
      @user = User.find(params[:id])
      @tasks = Task.search(user_id: @user.id, status: params[:status], keyword: params[:keyword], sort: params[:sort], direction: params[:direction]).page(params[:page])
    end

    def new
      @user = User.new
    end

    def edit
      @user = User.find(params[:id])
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
      @user = User.find(params[:id])

      if @user.update(user_params)
        flash[:success] = I18n.t('users.flash.update.success')
        redirect_to admin_users_path
      else
        flash.now[:danger] = I18n.t('users.flash.update.error')
        render :new
      end
    end

    def destroy
      if User.find(params[:id]).destroy
        flash[:success] = I18n.t('users.flash.destroy.success')
      else
        flash[:danger] = I18n.t('users.flash.destroy.success')
      end
      redirect_to admin_users_path
    end

    private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
