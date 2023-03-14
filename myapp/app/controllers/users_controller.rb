class UsersController < ApplicationController
  before_action :require_admin_login
  before_action :fetch_user_by_params_id, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = I18n.t('flash.user.create.success')
      return redirect_to @user
    end

    flash.now[:danger] = I18n.t('flash.user.create.failure')
    render 'new', status: :unprocessable_entity
  end

  def show
    @tasks = @user.tasks
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t('flash.user.update.success')
      return redirect_to @user
    end

    flash.now[:danger] = I18n.t('flash.user.update.failure')
    render 'edit', status: :unprocessable_entity
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t('flash.user.delete.success')
    else
      flash.now[:danger] = I18n.t('flash.user.delete.failure')
    end
    redirect_to users_url
  end

  private

  def fetch_user_by_params_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_admin)
  end

end
