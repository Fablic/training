# frozen_string_literal: true

class TasksController < ::ApplicationController
  SORTABLE_FIELDS = %w(id created_at due_date)
  SORTABLE_ORDERS = %w(asc desc)

  before_action :authorize_user
  before_action :set_task, only: %i[show edit update destroy start complete]

  def index
    tasks = params[:owner_filter] == "Others'" ? Current.user.editable_tasks : Current.user.tasks
    @tasks = TasksFinder.new(params: params, tasks: tasks).process
    @tasks = @tasks.includes(:limited_tags).order(sort_order).page(params[:page])
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

  def start
    if @task.start!
      redirect_to tasks_path, notice: 'task status updated'
    else
      render :show
      flash[:notice] = 'task status update failed'
    end
  end

  def complete
    if @task.complete!
      redirect_to tasks_path, notice: 'task status updated'
    else
      render :show
      flash[:notice] = 'task status update failed'
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :tag_list, :editable_user_list)
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def sort_order
    sort_column, sort_order = params[:order_by]&.split('-')
    sort_column = SORTABLE_FIELDS.find {|field| field == sort_column } || 'id'
    sort_order = SORTABLE_ORDERS.find {|field| field == sort_order } || 'asc'

    "#{sort_column} #{sort_order.upcase}"
  end
end
