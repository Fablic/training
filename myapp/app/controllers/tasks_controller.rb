# frozen_string_literal: true

class TasksController < ::ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'task created successfully'
    else
      flash[:notice] = 'task creation failed'
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'task updated successfully'
    else
      render :edit
      flash[:notice] = 'task update failed'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'delete successfully'
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
