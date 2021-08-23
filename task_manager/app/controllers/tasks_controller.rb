# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task_by_id, only: %i[show edit update destroy]
  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = t 'tasks.flash.create.success'
      redirect_to @task
    else
      flash[:danger] = t 'tasks.flash.create.danger'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = t 'tasks.flash.update.success'
      redirect_to @task
    else
      flash.now[:danger] = t 'tasks.flash.update.danger'
      render :new
    end
  end

  def destroy
    @task.destroy

    flash[:success] = t 'tasks.flash.destroy.success'
    redirect_to tasks_path
  end

  private

  def set_task_by_id
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :priority, :progress)
  end
end
