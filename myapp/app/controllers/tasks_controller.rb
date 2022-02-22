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
    # todo論理削除にする
    Task.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :deadline, :priority, :label_id, :status)
  end
end
