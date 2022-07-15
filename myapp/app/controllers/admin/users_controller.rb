# frozen_string_literal: true

class Admin::UsersController < ApplicationController # rubocop:disable Style/ClassAndModuleChildren
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

    if update_admin?
      if @user.update(user_params)
        flash[:success] = I18n.t('users.flash.update.success')
        redirect_to admin_users_path
      else
        flash.now[:danger] = I18n.t('users.flash.update.error')
        render :new
      end
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
    params.require(:user).permit(:name, :email, :password, :admin)
  end

  def update_admin?
    count_admin = User.where(admin: true).count
    return true if count_admin > 1
    # 最後に残ったアドミンユーザー、更新しようとしているユーザー != アドミンだとtrue
    # 最後に残っているユーザー　== 更新しようとしているユーザー（権限を更新していない時）true
    if count_admin == 1
      if User.where(admin: true) == current_user

      end
    end
  end
end
