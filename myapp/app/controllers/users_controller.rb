# frozen_string_literal: true

class UsersController < ApplicationController
  before_action lambda  {
    check_login_status
    check_user_role
  }

  def index
    # @conditions = params || {}
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = I18n.t('users.new.messages.success')
      redirect_to @user
    else
      flash.now[:danger] = I18n.t('users.new.messages.error')
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    # 権限を一般ユーザに編集してる場合最後の管理者かどうかをチェック
    if user_params[:role] == 'normal' && last_admin?(@user)
      flash.now[:danger] = I18n.t('auth.messages.last_admin')
      render :edit
      nil
    elsif @user.update(user_params)
      flash[:success] = I18n.t('users.edit.messages.success')
      redirect_to @user
    else
      flash.now[:danger] = I18n.t('users.edit.messages.error')
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if last_admin?(@user)
      flash.now[:danger] = I18n.t('auth.messages.last_admin')
      render :show
      nil
    elsif @user.destroy
      flash[:success] = I18n.t('users.destroy.messages.success')
      redirect_to users_path
    else
      flash[:danger] = I18n.t('users.destroy.messages.error')
      redirect_to request.url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def last_admin?(user)
    return true if user.admin? && User.admin_users.count < 2

    false
  end
end
