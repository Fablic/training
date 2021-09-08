# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user_by_id, only: %i[show edit update destroy]
  before_action :confirm_permission, only: %i[show edit update destroy]
  before_action :confirm_destroy, only: %i[destroy]
  skip_before_action :authenticate_user, only: %i[new create]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    return unless @user.save

    flash[:success] = I18n.t('controllers.flash.success', model: User.model_name.human, action: I18n.t('controllers.action.create'))
    log_in @user
    redirect_to root_path
  end

  def edit
  end

  def update
    return unless @user.update(user_params)

    flash[:success] = I18n.t('controllers.flash.success', model: User.model_name.human, action: I18n.t('controllers.action.update'))
    redirect_to @user
  end

  def destroy
    @user.destroy

    flash[:success] = I18n.t('controllers.flash.success', model: User.model_name.human, action: I18n.t('controllers.action.destroy'))
    redirect_to new_user_url
  end

  private

  def set_user_by_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def confirm_permission
    return if permitted?(@user.id)

    flash[:danger] = I18n.t 'sessions.flash.permission.denied'
    redirect_back(fallback_location: root_path)
  end

  def confirm_destroy
    return unless User.will_lose_administrators?(@user)

    flash[:danger] = I18n.t('admin.flash.confirm_update_admin.danger')
    redirect_to @user
  end
end
