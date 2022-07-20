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

  def update # rubocop:disable Metrics/AbcSize
    @user = User.find(params[:id])

    if update_admin(params)
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

  def update_admin(params)
    count_admin = User.where(admin: true).count

    if count_admin > 1 || User.find_by(admin: true).id != params[:id].to_i || params[:user][:admin] != 'member'
      return true
    end

    false
  end
end
