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
    task_params = params.require(:task).permit(:title, :content, :tag, :priority, :status, :due_date)
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, flash: {success: "登録が完了しました"}
    else
      flash.now[:alert] = "必須項目を埋めてください"
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    task_params = params.require(:task).permit(:title, :content, :tag, :priority, :status, :due_date)
    if @task.update(task_params)
      redirect_to tasks_path, flash: {success: "更新が完了しました"}
    else
      flash.now[:alert] = "必須項目を埋めてください"
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, flash: {success: "タスクを削除しました"}
  end
end
