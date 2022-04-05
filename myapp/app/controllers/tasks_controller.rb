# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(20)
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
    if @task.save
      redirect_to tasks_path, notice: "Saved a task '#{@task.name}'"
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Updated a task '#{@task.name}'"
    else
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_path, notice: "Deleted a task '#{task.name}'"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :status)
  end
end
