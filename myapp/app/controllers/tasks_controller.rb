class TasksController < ApplicationController
  def index
    @taskList = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      # 成功
      # redirect task/index
      flash[:success] = "保存しました"
      redirect_to @task
    else
      # 失敗
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      # 成功
      redirect_to @task
    else
      # 失敗
      render 'edit'
    end
  end

  def destroy
  end

  private

    def task_params
      params.require(:task).permit(:title, :body, :deadline, :priority, :label_id, :status)
    end
end
