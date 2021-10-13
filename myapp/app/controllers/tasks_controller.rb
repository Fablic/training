# frozen_string_literal: true

# task management
class TasksController < ApplicationController
  def show
#    @tasks = Task.all()
    @tasks = Task.search(params[:search])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])

  end

  def update
    @task = Task.find(params[:id])
  end

  def destroy
#    @task = find_task_by_id

    @task.destroy
    redierct_to dask_path
  end

  def create
    @task = Task.new(post_params)
    if (@task.save)
      flash[:notice] = 'Task registration is complete.'
      redirect_to '/tasks/'
    else
      render action:new
    end
  end

  private
  def post_params
    params.require(:task).permit(:task_name, :description, :status, :priority, :label, :start_date, :end_date)
  end

end
