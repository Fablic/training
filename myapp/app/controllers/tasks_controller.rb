# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :logged_in_user
  def index
    @tasks = if Task.statuses.keys.include?(params[:status])
                Task.includes([:user])
                  .user_id_search(current_user.id)
                  .task_name_partial_search(params[:task_name])
                  .where(status: params[:status])
                  .page(params[:page])
             else
                Task.includes([:user])
                  .user_id_search(current_user.id)
                  .task_name_partial_search(params[:task_name])
                  .page(params[:page])
             end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to @task, notice: 'タスクを登録しました。'
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
    if @task.user.id == current_user.id
      task_path(@task)
    else
      render_404
    end
  end

  def edit
    @task = Task.find(params[:id])
    if @task.user.id == current_user.id
      task_path(@task)
    else
      render_404
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "ID#{@task.id}のタスクを更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'タスクを削除しました。'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :description, :starts_on, :ends_on, :priority, :label, :status)
  end
end
