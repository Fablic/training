class TasksController < ApplicationController
  before_action :set_task, only: %i[edit show]

  def index
    @tasks = Task.all
    @status = params[:status]
    @name = params[:name]
    @tasks = @tasks.where(status: @status) if @status.present?
    @tasks = @tasks.where(name: @name) if @name.present?
  end

  def create
    @task = Task.new(params.require(:task).permit(:name, :description, :status))
    if @task.save
      redirect_to tasks_path, notice: I18n.t('notice.task.insert.success')
    else
      render :edit
    end
  end

  def new
    @task = Task.new
    render :edit
  end

  def edit; end

  def show; end

  def update
    @task = Task.find(params[:id])
    if @task.update(params.require(:task).permit(:name, :description, :status))
      redirect_to tasks_path, notice: I18n.t('notice.task.update.success')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.delete
      redirect_to tasks_path, notice: I18n.t('notice.task.delete.success')
    else
      flash.now[:alert] = I18n.t('notice.task.delete.fail')
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
