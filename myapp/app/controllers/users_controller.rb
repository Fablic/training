class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_data = params.require(:user).permit(:username, :password, :password_confirmation)

    @user = User.new(user_data)

    if @user.save 
      log_in(@user)
      redirect_to tasks_path, notice: 'Successfully signed up!' 
    else 
      render :new
    end
  end

  def admin
    @users_with_count = User.with_tasks_count
  end

  def destroy 
    user = find_user_by_id
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
  end

  def update
    @user = find_user_by_id
    if @user.update(user_params)
      redirect_to admin_path, notice: "Successfully updated user #{@user.username}"
    else 
      render :edit
    end
  end

  def user_tasks
    @tasks = find_user_by_id.tasks
  end

  private 

  def find_user_by_id
    User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
