class Admin::UsersController < Admin::Base
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.order(created_at: :desc).page(params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: t('admin.users.flash.create')
    else
      render :new
    end
  end

  def edit; end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: t('admin.users.flash.update')
    else
      render :edit
    end
  end

  def destroy
    if @user.is_admin? && last_admin_user?
      redirect_to admin_users_path, alert: t('admin.users.flash.last_admin_user')
    elsif @user == current_admin
      redirect_to admin_users_path, alert: t('admin.users.flash.current_login_user')
    else
      @user.destroy!
      redirect_to admin_users_path, notice: t('admin.users.flash.delete')
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :is_admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def last_admin_user?
    User.admin.count == 1
  end
end
