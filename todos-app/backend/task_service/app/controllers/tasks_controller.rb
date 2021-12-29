# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  # GET /tasks
  def index
    @tasks = Task.all
    @tasks = @tasks.where(status: status_param) if status_param

    @tasks = @tasks.order(sort_param[0] => sort_param[1]) if sort_param

    @tasks = @tasks.where('title LIKE ?', "%#{params[:search]}%") if params[:search]

    render json: @tasks
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    @task.save!
    render json: @task, status: :created, location: @task
  end

  # PATCH/PUT /tasks/1
  def update
    @task.update!(task_params)
    render json: @task
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:user_id, :title, :description, :priority, :status, :due_datetime)
  end

  def sort_param
    # Possible sort params
    sort_params = %w[created_at:desc created_at:asc updated_at:desc updated_at:asc due_datetime:desc due_datetime:asc]
    return unless params[:sort]

    raise Exceptions::InvalidSortParams, "#{params[:sort]} is not a valid sort param" unless sort_params.include?(params[:sort])

    [params[:sort].split(':')[0], params[:sort].split(':')[1]]
  end

  def status_param
    # Possible status params
    status_params = %w[not_started in_progress done]
    return unless params[:status]

    raise Exceptions::InvalidStatusParams, "#{params[:status]} is not a valid status param" unless status_params.include?(params[:status])

    params[:status]
  end
end
