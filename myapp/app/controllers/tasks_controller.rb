# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if params && (params[:word].present? || params[:status].present?)
      @tasks = Task.search(params[:word], Task.statuses[params[:status]])
    else
      @tasks = Task.all.order('tasks.created_at desc')
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1

    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を登録しました。"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を更新しました。"
    else
      render :new
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を削除しました。"
    else
      render :show
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
