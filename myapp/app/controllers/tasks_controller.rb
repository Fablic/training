class TasksController < ApplicationController
  def index
    @taskList = Task.all
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
      # 成功
      flash[:success] = "保存しました"
      redirect_to @task # Tasks#showへ
    else
      # 失敗
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
      # 成功
      flash[:success] = "保存しました"
      redirect_to @task
    else
      # 失敗
      flash.now[:alert] = "保存に失敗しました"
      render 'edit'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to tasks_url
  end

  private

    def task_params
      params.require(:task).permit(:user_id, :title, :body, :deadline, :priority, :label_id, :status)
    end
end
