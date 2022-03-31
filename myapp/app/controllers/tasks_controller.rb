# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :logged_in_user
  def index
    @tasks = current_user.tasks.includes([:task_labels]).includes([:labels])
                         .task_name_partial_search(params[:task_name])
                         .status_search(params[:status])
                         .label_name_search(params[:label_name])
                         .page(params[:page])
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
    if @task
      task_path(@task)
    else
      render_404
    end
  end

  def edit
    if @task
      task_path(@task)
    else
      render_404
    end
  end

  def update
    if @task
      if @task.update(task_params)
        redirect_to @task, notice: "ID#{@task.id}のタスクを更新しました。"
      else
        render :edit
      end
    else
      render_404
    end
  end

  def destroy
    if @task
      if @task.destroy
        redirect_to tasks_url, notice: 'タスクを削除しました。'
      end
    else
      render_404
    end
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :description, :starts_on, :ends_on, :priority, { label_ids: [] }, :status)
  end
end
