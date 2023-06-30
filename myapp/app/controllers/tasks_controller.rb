# frozen_string_literal: true

# some comments here for task controller
class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.search_by_name(search_params[:search_name])
                 .search_by_status(search_params[:search_status])
                 .sort_by_column(sort_params[:sort_column], sort_params[:sort_direction])
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

  def sort_params
    params.permit(sort: [:column, :direction])
    if params[:sort].present?
      {
        sort_column: Task.column_names.include?(params[:sort][:column]) ? params[:sort][:column] : 'created_at',
        sort_direction: %w[ASC DESC].include?(params[:sort][:direction]) ? params[:sort][:direction] : 'ASC',
      }
    else
      {
        sort_column: 'created_at',
        sort_direction: 'ASC',
      }
    end
  end

  def search_params
    params.permit(search: [:name, :status])

    if params[:search].present?
      {
        search_name: params[:search][:name],
        search_status: params[:search][:status],
      }
    else
      {
        search_name: nil,
        search_status: nil,
      }
    end
  end
end
