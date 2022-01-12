# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: %i[show update destroy]
  before_action :set_labels, only: %i[create update]

  # GET /tasks
  def index
    @tasks = Task.where(user_id: @user_id)
    @tasks = @tasks.where(status: status_param) if status_param

    @tasks = @tasks.order(sort_param[0] => sort_param[1]) if sort_param

    if params[:search]
      @tasks = @tasks
                 .distinct
                 .left_outer_joins(:labels)
                 .where('tasks.title LIKE ? OR labels.name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end
    total_count = @tasks.count

    @tasks = @tasks.offset(pagination_params[:offset]).limit(pagination_params[:limit])
    render json: { tasks: @tasks.as_json(include: { labels: { only: :name } }), total_count: total_count }
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params.merge!(user_id: @user_id))
    @task.labels = @labels if @labels
    @task.save!
    render json: @task.as_json(include: { labels: { only: :name } }), status: :created, location: @task
  end

  # PATCH/PUT /tasks/1
  def update
    @task.assign_attributes(task_params.merge!(user_id: @user_id))
    @task.labels = @labels if @labels
    @task.save!
    render json: @task.as_json(include: { labels: { only: :name } })
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  def destroy_all
    params.require(:user_id)
    @tasks = Task.where(user_id: @user_id)
    @tasks.destroy_all
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def set_labels
    return unless params[:task][:labels]

    unless params[:task][:labels].is_a?(Array) && !params[:task][:labels].empty?
      raise Exceptions::InvalidLabelParams, 'Labels attribute must be a non-empty array'
    end

    @labels = []
    params[:task][:labels].each { |name| @labels.push(Label.where(user_id: @user_id, name: name).first_or_initialize) }
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_datetime)
  end

  def sort_param
    # Possible sort params
    sort_params = %w[created_at:desc created_at:asc updated_at:desc updated_at:asc due_datetime:desc due_datetime:asc]
    return unless params[:sort]

    raise Exceptions::InvalidSortParams, "#{params[:sort]} is not a valid sort param" unless sort_params.include?(params[:sort])

    [params[:sort].split(':')[0], params[:sort].split(':')[1]]
  end

  def status_param
    return unless params[:status]

    raise Exceptions::InvalidStatusParams, "#{params[:status]} is not a valid status param" unless Task.statuses.include?(params[:status])

    params[:status]
  end

  def pagination_params
    if params[:offset].nil?
      @offset = 0
    else
      begin
        @offset = Integer(params[:offset])
      rescue ArgumentError
        raise Exceptions::InvalidPaginationParams, "Given offset #{params[:offset]} is not integer"
      end
    end

    if params[:limit].nil?
      @limit = 20
    else
      begin
        @limit = Integer(params[:limit])
      rescue ArgumentError
        raise Exceptions::InvalidPaginationParams, "Given limit #{params[:limit]} is not integer"
      end
    end

    { offset: @offset, limit: @limit }
  end
end
