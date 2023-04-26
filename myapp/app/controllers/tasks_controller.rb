class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('flash.task.create.notice')
    else
      flash.now[:alert] = t('flash.task.create.alert')
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('flash.task.update.notice')
    else
      flash.now[:alert] = t('flash.task.update.alert')
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('flash.task.delete.notice')
  end

  def show; end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def record_not_found
    redirect_to root_path, alert: t('flash.task.record_not_found.alert')
  end

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
