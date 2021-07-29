class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.without_deleted.tasks_count
  end

  def show
    @tasks = Task.without_deleted
                 .includes_status
                 .includes_priority
                 .includes_user(@user.id)
                 .sort_task('tasks.created_at desc')
                 .page(params[:page])
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path, notice: 'ユーザ情報を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 論理削除
  def destroy
    if current_user.id == @user.id
      redirect_to admin_users_path, notice: 'ログイン中のユーザは削除できません。'
    else
      now = Time.current
      @user.update(deleted_at: now)
      @user.tasks.without_deleted.update(deleted_at: now)
      redirect_to admin_users_path, notice: 'ユーザを削除しました。'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:user_name, :email)
  end
end
