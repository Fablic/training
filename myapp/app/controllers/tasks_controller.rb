class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :delete]

  def index
    @tasks = Task.all
  end

  def show

  end

  def new
    @task = Task.new()
  end

  def create
    task = Task.new(task_param)
    task.save!
    redirect_to tasks_url, notice: 'タスク「#{task.name}」を登録しました。'
  end

  def edit
  end

  private
    def task_param
      params.require(:task).permit(:name, :detail, :status, :priority)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
