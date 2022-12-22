# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user

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

    if @user.update(user_params)
      flash[:success] = I18n.t('users.edit.messages.success')
      redirect_to @user
    else
      flash.now[:danger] = I18n.t('users.edit.messages.error')
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = I18n.t('users.destroy.messages.success')
      redirect_to root_path
    else
      flash[:danger] = I18n.t('users.destroy.messages.error')
      redirect_to request.url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
