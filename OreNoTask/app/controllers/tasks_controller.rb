# frozen_string_literal: true
class TasksController < ApplicationController
  def index
    @tasks = Task.where(deleted: 0)
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find_by(id: params[:id], deleted: 0)
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクが更新されました'
    else
      render edit, notice: 'タスクの更新に失敗しました'
    end
  end

  def show
    id = params[:id]
    @task = Task.find_by(id: id, deleted: 0)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'タスクが作成されました'
    else
      render new, notice: 'タスクの作成に失敗しました'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.update(deleted: 1)
      redirect_to tasks_path, notice: 'タスクが削除されました'
    else
      redirect_to tasks_path, notice: 'タスクの削除に失敗しました'
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :start_at, :due_date_at)
  end

end
