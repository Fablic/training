# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: %i[show edit update destroy]

  VALID_SORT_COLUMNS = %w[created_at deadline].freeze
  VALID_SORT_DIRECTIONS = %w[asc desc].freeze

  # GET /tasks
  def index
    sort_by = VALID_SORT_COLUMNS.include?(params[:sort_by]) ? params[:sort_by] : 'created_at'
    sort_direction = VALID_SORT_DIRECTIONS.include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'

    @tasks = current_user.tasks.order("#{sort_by} #{sort_direction}")

    @tasks = @tasks.where('title LIKE ?', "%#{params[:title]}%") if params[:title].present?

    @tasks = @tasks.where(status: params[:status]) if params[:status].present?

    @tasks = @tasks.page(params[:page]).per(12)
  end

  def show
    # @task is set by the before_action :set_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to @task
    else
      render :new
    end
  end

  def edit
    # @task is set by the before_action :set_task
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = 'Task was successfully updated.'
      redirect_to @task
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = 'Task was successfully deleted.'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
