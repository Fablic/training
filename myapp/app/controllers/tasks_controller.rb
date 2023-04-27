class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @tasks = Task.all.order(created_at: 'DESC')
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('messages.create', model_name: t('activerecord.models.task'))
    else
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('messages.update', model_name: t('activerecord.models.task'))
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('messages.delete', model_name: t('activerecord.models.task'))
  end

  def show; end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def record_not_found
    redirect_to root_path, alert: t('error.messages.record_not_found', model_name: t('activerecord.models.task'))
  end

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
