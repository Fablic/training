# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(20)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Saved a task '#{@task.name}'"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Updated a task '#{@task.name}'"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Deleted a task '#{@task.name}'"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :status)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
