class TasksController < ApplicationController
  before_action :fetch_task_by_params_id, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
    @task_columns_with_sorting_direction = task_columns_with_sorting_direction

    @tasks = @tasks.order("#{params[:sort_key]} #{sort_direction}") if params[:sort_key].present?
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = I18n.t('flash.task.create.success')
      return redirect_to @task
    end

    flash[:error] = I18n.t('flash.task.create.failure')
    render 'new', status: :unprocessable_entity
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t('flash.task.update.success')
      return redirect_to @task
    end

    flash[:error] = I18n.t('flash.task.update.failure')
    render 'edit', status: :unprocessable_entity
  end

  def destroy
    if @task.destroy
      flash[:success] = I18n.t('flash.task.delete.success')
    else
      flash[:error] = I18n.t('flash.task.delete.failure')
    end
    redirect_to tasks_url
  end

  private

  def fetch_task_by_params_id
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :deadline_at)
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

  def reversed_sort_direction
    sort_direction == 'asc' ? 'desc' : 'asc'
  end

  def task_columns_with_sorting_direction
    Task.column_names.map do |column_name|
      next if column_name == 'description'
      {
        name: column_name,
        sort_direction: params[:sort_key] == column_name ? reversed_sort_direction : 'asc',
      }
    end.compact
  end
end
