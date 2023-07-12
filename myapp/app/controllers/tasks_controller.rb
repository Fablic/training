# frozen_string_literal: true

# some comments here for task controller
class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :index_page_params, only: [:index]
  before_action :logged_in_user

  def index
    @tasks = Task.search_by_name(@search_name)
                 .search_by_status(@search_status)
                 .sort_by_column(@sort_column, @sort_direction)
                 .page(params[:page])
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
      redirect_to task_path(@task), flash: { success: t('flash_msgs.update_ok') }
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
    params.require(:task).permit(:name, :description, :priority, :expired_date, :status).merge(user_id: @current_user.id)
  end

  def index_page_params
    params.permit(search: [:name, :status, :column, :direction])
    if params[:search].present?
      @search_name = params[:search][:name]
      @search_status = params[:search][:status]
      @sort_column = params[:search][:column]
      @sort_direction = params[:search][:direction]
    else
      @search_name = ''
      @search_status = ''
      @sort_column = 'created_at'
      @sort_direction = 'ASC'
    end
  end
end
