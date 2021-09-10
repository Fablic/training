class TasksController < ApplicationController
  before_action :_logged_in_user

  def index
    params[:q] = { sorts: 'created_at desc' } if params[:q].blank?
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result.page(params[:page])
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, flash: { success: I18n.t('flash.new_success') }
    else
      flash[:danger] = I18n.t('flash.new_danger')
      flash[:validation_error] = @task.errors.full_messages
      redirect_to new_task_path
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to @task, flash: { success: I18n.t('flash.updated_success') }
    else
      flash[:danger] = I18n.t('flash.updated_danger')
      flash[:validation_error] = @task.errors.full_messages
      redirect_to edit_task_path(@task)
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    redirect_to root_path, flash: { success: I18n.t('flash.destroy') }
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status)
  end
end
