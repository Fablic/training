class TasksController < ApplicationController
  def index
    @tasks = Task.all
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
    task = Task.new(task_params)
    task.save!
    redirect_to tasks_path, notice: "Saved a task '#{task.name}'"
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
    redirect_to tasks_path, notice: "Updated a task '#{task.name}'"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
