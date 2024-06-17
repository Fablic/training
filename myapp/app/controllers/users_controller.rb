class UsersController < ApplicationController
  before_action :redirect_if_not_admin

  def admin
    @users_with_count = User.with_tasks_count
  end

  def destroy 
    user = find_user_by_id
    redirect_to admin_path, notice: 'User not found!' unless user 
    username = user.username
    user.destroy 

    redirect_to admin_path, notice: "Successfully deleted user: #{username}"
  end

  def new_user
    @user = User.new
  end

  # TODO: Integrate to #create after role feature is added
  def create_user
    user_data = params.require(:user).permit(:username, :password, :password_confirmation)

    @user = User.new(user_data)

    if @user.save 
      log_in(@user)
      redirect_to admin_path, notice: 'Successfully signed up!' 
    else 
      render :new_user
    end
  end

  def edit 
    @user = find_user_by_id
    redirect_to admin_path, notice: 'User not found!' unless @user
    @myself = params[:id].to_i == session[:user_id]
  end

  def update_info
    @user = find_user_by_id
    redirect_to admin_path, notice: 'User not found!' unless @user 

    info = user_params_info
    # when resigning the last one admin user
    if @user.admin && !info[:admin] && (admin_count == 1)
      redirect_to admin_path, notice: "Should keep at least one admin user!"
    elsif @user.update(info)
      redirect_to admin_path, notice: "Successfully updated user #{@user.username}"
    else 
      render :edit
    end
  end

  def update_password
    @user = find_user_by_id
    redirect_to admin_path, notice: 'User not found!' unless @user 
    if @user.update(user_params_password)
      redirect_to admin_path, notice: "Successfully updated user #{@user.username}"
    else 
      render :edit
    end
  end

  def user_tasks
    user = find_user_by_id
    unless user 
      redirect_to admin_path, notice: 'User not found!' unless user 
      return
    end
    @tasks = user.tasks
  end

  private 

  def find_user_by_id
    User.find_by(id: params[:id])
  end

  def user_params_info
    params.require(:user).permit(:username, :admin)
  end

  def user_params_password
    params.require(:user).permit(:password, :password_confirmation)
  end

  def admin_count
    User.where(admin: true).count
  end
end
