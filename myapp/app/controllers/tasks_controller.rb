class TasksController < ApplicationController
  def index
    # @taskList = Task.all
    # 論理削除
    @taskList = Task.where(deleted: false)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @task.user_id = 1
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "保存しました"
      redirect_to @task # Tasks#showへ
    else
      flash.now[:alert] = "保存に失敗しました"
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "保存しました"
      redirect_to @task
    else
      flash.now[:alert] = "保存に失敗しました"
      render 'edit'
    end
  end

  def destroy
    task = Task.find(params[:id])
    # if task.destroy
    # 論理削除に修正
    if task.update(deleted: true)
      flash[:success] = "削除しました"
      redirect_to tasks_url
    else
      flash[:alert] = "削除に失敗しました"
      redirect_to tasks_url
    end
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :deadline, :priority, :label_id, :status)
  end
end
