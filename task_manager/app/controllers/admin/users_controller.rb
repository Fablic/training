# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :set_user_by_id, only: %i[show edit update destroy]
  def index
    @users = User.search_name(params[:keyword]).or(User.search_email(params[:keyword])).page(params[:page]).per(5)
  end

  def show
  end

  def edit
  end

  def update
    return unless @user.update(user_params)

    flash[:success] = I18n.t('controllers.flash.success', model: User.model_name.human, action: I18n.t('controllers.action.update'))
    redirect_to [:admin, @user]
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
end
