# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[edit update destroy]

  def index
    @tasks = Task.search(params, current_user.tasks).page(params[:page])
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to root_url, flash: { success: create_flash_message('create', 'success', @task, :name) }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_url, flash: { success: create_flash_message('update', 'success', @task, :name) }
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = create_flash_message('destroy', 'success', @task, :name)
    else
      flash[:danger] = create_flash_message('destroy', 'failed', @task, :name)
    end

    redirect_to root_url
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :due_date, :priority, :status, label_ids: [])
  end

  def find_task
    @task = current_user.tasks.find(params[:id])
  end
end
