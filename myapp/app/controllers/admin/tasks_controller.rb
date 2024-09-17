class Admin::TasksController < ApplicationController
  before_action :redirect_to_login_path_if_not_logged_in, :redirect_to_root_path_if_normal_role

  def index
    id = params[:id]
    @user = User.with_deleted.find_by(id: id)
    return redirect_to error_path(404) if @user.nil?

    @tasks = Task.with_deleted.where(user_id: id).page(params[:page])
    Rails.logger.info(@tasks)
  end

  def destroy
    @task = Task.with_deleted.find_by(id: params[:id])
    if @task.nil?
      flash[:danger] = I18n.t 'msg_delete_failure'
      return redirect_to admin_users_path
    end

    @task.destroy
    flash[:success] = I18n.t 'msg_delete_success'
    redirect_to admin_user_tasks_path(@task.user_id)
  end
end
