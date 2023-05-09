class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy show]

  def index
    @tasks = if params[:deadline_updated]
               Task.updated
             elsif params[:deadline_created]
               Task.created
             else
               Task.all.order(created_at: 'DESC')
             end
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('messages.create', model_name: t('activerecord.models.task'))
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('messages.update', model_name: t('activerecord.models.task'))
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, notice: t('messages.delete', model_name: t('activerecord.models.task'))
    else
      render :index
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline)
  end
end
