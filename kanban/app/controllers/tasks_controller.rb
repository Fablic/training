class TasksController < ApplicationController
  before_action :set_task, only: %i[edit show]

  def index
    @all_tasks = Task.all
  end

  def create
    @task = Task.new(params.require(:task).permit(:name, :description))
    if @task.save
      redirect_to tasks_path, notice: 'タスクの登録に成功しました'
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
    if @task.update(params.require(:task).permit(:name, :description))
      redirect_to tasks_path, notice: 'タスクの更新に成功しました'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.delete
      redirect_to tasks_path, notice: 'タスクの削除に成功しました'
    else
      flash.now[:alert] = 'タスクの削除に失敗しました'
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
