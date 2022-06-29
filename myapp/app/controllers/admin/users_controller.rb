class Admin::UsersController < ApplicationController
  before_action :admin_user
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

    return render 'new' unless @user.save

    flash[:success] = 'User created'
    redirect_to admin_users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    return render 'edit' unless @user.update(user_params)

    flash[:success] = 'User updated!'
    redirect_to admin_users_path
  end

  def destroy
    # 自分を指定しても消せないようにする
    return redirect_to admin_users_path if params[:id].to_i == session[:user_id]

    User.find(params[:id]).destroy

    flash[:success] = 'User deleted!'
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def admin_user
    redirect_to root_path unless admin?
  end
end
