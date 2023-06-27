# frozen_string_literal: true

# some comments here for task controller
class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.order("#{task_list_params[:sort_column]} #{task_list_params[:sort_direction]}")
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, flash: { success: t('flash_msgs.create_ok') }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, flash: { success: t('flash_msgs.update_ok') }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, flash: { success: t('flash_msgs.delete_ok') }
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :expired_date, :status)
  end

  def task_list_params
    params.permit(:sort_column, :sort_direction)
    {
      sort_column: Task.column_names.include?(params[:sort_column]) ? params[:sort_column] : 'created_at',
      sort_direction: %w[ASC DESC].include?(params[:sort_direction]) ? params[:sort_direction] : 'ASC',
    }
  end
end
