class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :current_user
  before_action :redirect_top_by_general_user
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
    if current_user.id == @user.id && user_params[:role] == 'false'
      redirect_to admin_users_path, notice: 'ログイン中のユーザの管理者権限は変更できません。'
      return
    end

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
      now = Time.current.strftime('%Y-%m-%d %H:%M:%S')
      begin
        ActiveRecord::Base.transaction do
          @user.update!(deleted_at: now)
          @user.tasks.without_deleted.each { |user_task| user_task.update!(deleted_at: now) }
        end
        redirect_to admin_users_path, notice: 'ユーザを削除しました。'
      rescue StandardError => e
        Rails.logger.error e
        redirect_to admin_users_path, notice: 'ユーザの削除を失敗しました。'
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:user_name, :email, :role)
  end

  def redirect_top_by_general_user
    redirect_to root_path unless current_user.role
  end
end
