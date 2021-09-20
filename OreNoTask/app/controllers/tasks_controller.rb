# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.where(deleted: 0)
  end

  def new
    @task = Task.new
    @submit_label = '作成'
  end

  def edit
    @task = Task.find_by(id: params[:id], deleted: 0)
    @submit_label = '更新'
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
    flash[:notice] = if @task.update(deleted: 1)
                       'タスクが削除されました'
                     else
                       'タスクの削除に失敗しました'
                     end

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :start_at, :due_date_at)
  end
end
