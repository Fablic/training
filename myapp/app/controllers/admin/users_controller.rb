class Admin::UsersController < ApplicationController
  include Admin::UsersHelper
  before_action :check_admin_user
  PAGE_NUM = 10

  def index
    @users = User.includes(:tasks).all.page(params[:page]).per(PAGE_NUM)
  end

  def tasks
    @tasks = User.find_by(id: params[:id]).tasks
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    unless @user.save
      flash[:danger] = @user.errors.full_messages.join('<br>')
      return render 'new'
    end

    flash[:success] = I18n.t('admin.users.create.flash_created')
    redirect_to admin_users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # adminが0人になる場合は保存しない
    if @user.admin? && user_params[:role] == 'normal' && User.count_admin_user == 1
      flash[:danger] = I18n.t('admin.users.update.flash_req')
      return redirect_to admin_users_path
    end
    # その他で保存できないとき
    unless @user.update(user_params)
      flash[:danger] = @user.errors.full_messages.join('<br>')
      return render 'edit'
    end

    flash[:success] = I18n.t('admin.users.update.flash_update')
    redirect_to admin_users_path
  end

  def destroy
    user = User.find(params[:id])
    # 自分を指定しても消せないようにする
    if params[:id].to_i == session[:user_id]
      flash[:danger] = I18n.t('admin.users.destroy.flash_delete_me')
      return redirect_to admin_users_path
    end

    user.destroy
    flash[:success] = I18n.t('admin.users.destroy.flash_deleted')
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def check_admin_user
    redirect_to root_path unless admin?
  end
end
