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
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def admin_user
    redirect_to root_path unless admin?
  end
end
