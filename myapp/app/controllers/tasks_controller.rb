class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      # タスク作成を通知
      flash[:success] = "タスクを作成しました"
      redirect_to @task
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :priority, :status)
    end
end
