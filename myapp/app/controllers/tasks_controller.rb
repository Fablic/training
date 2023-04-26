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
      redirect_to tasks_path, notice: t('messages.created', item: @task.title)
    else
      flash.now[:alert] = t('error_messages.created', item: @task.title)
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('messages.changed', item: @task.title)
    else
      flash.now[:alert] = t('error_messages.changed', item: @task.title)
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('messages.deleted', item: @task.title)
  end

  def show; end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def record_not_found
    redirect_to root_path, alert: t('errors_message.record_not_found')
  end

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
