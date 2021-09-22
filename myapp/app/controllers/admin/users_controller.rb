class Admin::UsersController < ApplicationController
  ADMIN_USER_MIN = 1

  before_action { _login_check || _check_role_admin }
  before_action :_set_user, only: %i[show edit update destroy]

  def index
    @users = User.preload(:tasks)
  end

  def show
    @tasks = Task.where(user_id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, flash: { success: I18n.t('flash.new_user_success') }
    else
      flash[:danger] = I18n.t('flash.new_user_danger')
      flash[:validation_error] = @user.errors.full_messages
      redirect_to new_admin_user_path
    end
  end

  def edit
    # before_actionのみ
  end

  def update
    if _can_change_role? && @user.update(user_params)
      redirect_to admin_users_path, flash: { success: I18n.t('flash.updated_user_success') }
    else
      flash[:danger] = I18n.t('flash.updated_user_danger')
      flash[:validation_error] = @user.errors.full_messages
      redirect_to edit_admin_user_path(@user)
    end
  end

  def destroy
    if current_user == @user
      flash[:danger] = I18n.t('flash.user_destroy_danger')
      flash[:info] = I18n.t('flash.cannot_update_admin', num: ADMIN_USER_MIN)
    else
      @user.destroy
      flash[:success] = I18n.t('flash.user_destroy_success')
    end

    redirect_to admin_users_path
  end

  def user_params
    params.require(:user).permit(:name, :password, :role)
  end

  private

  def _check_role_admin
    redirect_to routing_error unless current_user.admin?
  end

  def _can_change_role?
    return true unless @user.admin?
    return true if user_params[:role].to_sym == :admin
    return true if User.admin.count > ADMIN_USER_MIN

    flash[:info] = I18n.t('flash.cannot_update_admin', num: ADMIN_USER_MIN)
    false
  end

  def _set_user
    @user = User.find(params[:id])
  end
end
