class Admin::UsersController < ApplicationController
  before_action :redirect_to_login_path_if_not_logged_in, :redirect_to_root_path_if_normal_role

  def index
    @new_user = User.new

    @users = User.with_deleted.all.page(params[:page])
    @tasks_count_map = get_task_count_map(@users)
  end

  def create
    @user = User.new(create_params)
    if @user.save
      flash[:success] = I18n.t 'msg_create_success'

      redirect_to admin_users_path
    else
      flash.now[:danger] = I18n.t 'msg_create_failure'

      @new_user = @user
      @users = User.with_deleted.all.page(params[:page])
      @tasks_count_map = get_task_count_map(@users)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.with_deleted.find_by(id: params[:id])
  end

  def show
    redirect_to edit_admin_user_path(params[:id])
  end

  def update
    @user = User.with_deleted.find_by(id: params[:id])
    return redirect_to error_path(404) if @user.nil?

    Rails.logger.info("params => #{update_params}")
    if @user.update(update_params)
      flash[:success] = I18n.t 'msg_update_success'
      redirect_to edit_admin_user_path
    else
      flash.now[:danger] = I18n.t 'msg_update_failure'
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    @user = User.with_deleted.find_by(id: params[:id])
    if @user.nil?
      flash[:danger] = I18n.t 'msg_delete_failure'
      return redirect_to admin_users_path
    end

    if @user.role_admin?
      flash[:danger] = I18n.t 'msg_delete_admin_failure'
      return redirect_to admin_users_path
    end

    if @user.id == current_user.id
      flash[:danger] = I18n.t 'msg_delete_self_failure'
      return redirect_to admin_users_path
    end

    @tasks = Task.where(user_id: @user.id)

    result = ActiveRecord::Base.transaction do
      @user.destroy!
      # delete tasks that belongs to this user
      @tasks.destroy_all
    end

    unless result
      flash[:danger] = I18n.t 'msg_delete_failure'
      return redirect_to admin_users_path
    end

    flash[:success] = I18n.t 'msg_delete_success'
    redirect_to admin_users_path
  end

  private

  def create_params
    # value from select field is string, convert it to int explicitly here
    params[:user][:role] = params[:user][:role].to_i
    params.require(:user).permit(:name, :password, :password_confirmation, :role)
  end

  def update_params
    # value from select field is string, convert it to int explcitly here
    params[:user][:role] = params[:user][:role].to_i
    params.require(:user).permit(:password, :password_confirmation, :role)
  end

  def get_task_count_map(users)
    tasks_count_map = {}
    unless users.nil?
      user_id_ary = []
      users.each do |u|
        user_id_ary.push(u.id)
      end

      tasks_count_map = Task.with_deleted.where(user_id: user_id_ary).group(:user_id).count
      Rails.logger.info(tasks_count_map)
    end

    tasks_count_map
  end
end
