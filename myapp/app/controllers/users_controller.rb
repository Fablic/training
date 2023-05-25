class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user_id, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:tasks).order(created_at: 'DESC').page(params[:page]).per(5)
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, success: t('messages.create', model_name: t('activerecord.models.user'))
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, success: t('messages.update', model_name: t('activerecord.models.user'))
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, success: t('messages.delete', model_name: t('activerecord.models.user'))
    else
      render :index
    end
  end

  private

  def set_user_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
