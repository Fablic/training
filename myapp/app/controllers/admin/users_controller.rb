class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.active
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = I18n.t 'msg_account_create_success'
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = I18n.t 'msg_account_create_failure'
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = I18n.t 'msg_user_update_success'
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = "You cannot delete your own account."
      return redirect_to admin_users_path
    end

    if @user.is_admin?
      active_admin_count = User.active.where(is_admin: true).count
      if active_admin_count <= 1
        flash[:alert] = "Cannot delete the last active admin user."
        return redirect_to admin_users_path
      end
    end

    if @user.soft_delete
      flash[:notice] = "User was successfully soft-deleted."
    else
      flash[:alert] = "User deletion failed."
    end

    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.active.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :username, :password, :is_admin)
  end

  def require_admin
    raise ActionController::RoutingError, "404" unless current_user&.is_admin?
  end
end
