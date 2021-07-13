# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)

  def index
    @tasks = Task.order(updated_at: :desc)
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash.notice = "Task successfully created"
      redirect_to root_path
    else
      flash.alert = "Failed to create"
      render "new"
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      flash.notice = "Task successfully updated"
      redirect_to root_path
    else
      flash.alert = "Failed to update"
      render "edit"
    end
  end

  def destroy
    if @task.destroy
      flash.notice = "Task successfully deleted"
    else
      flash.alert = "Failed to delete"  
    end
    redirect_to root_path
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description)
    end
end
