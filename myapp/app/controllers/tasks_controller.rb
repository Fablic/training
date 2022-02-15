class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.priority_point = @task.cal_priority_point
    @task.save
    redirect_to root_path, notice: '新しいタスクを作成しました'
  end

  def index; end

  def list
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.priority_point = Task.new(task_params).cal_priority_point
    task.update(task_params)
    redirect_to root_path, notice: '#' + params[:id] + 'を更新しました'
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to root_path, notice: '#' + params[:id] + 'を削除しました'
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :status, :urgency, :importance, :deadline)
  end
end
