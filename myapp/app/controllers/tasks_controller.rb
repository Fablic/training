class TasksController < ApplicationController
  before_action :fetch_task_by_params_id, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
    @sort_order = reversed_sort_direction
    @tasks = @tasks.order(created_at: sort_direction.to_sym)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    # TODO: add validation to Task model
    if @task.save
      flash[:success] = t('flash.task.create.success')
      return redirect_to @task
    end

    flash[:error] = t('flash.task.create.failure')
    render 'new'
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = t('flash.task.update.success')
      return redirect_to @task
    end

    flash[:error] = t('flash.task.update.failure')
    render 'edit'
  end

  def destroy
    if @task.destroy
      flash[:success] = t('flash.task.delete.success')
    else
      flash[:error] = t('flash.task.delete.failure')
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
    %w[asc desc].include?(params[:sort_created_at]) ? params[:sort_created_at] : 'asc'
  end

  def reversed_sort_direction
    sort_direction == "asc" ? "desc" : "asc"
  end

end
