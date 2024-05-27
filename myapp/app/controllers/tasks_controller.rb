class TasksController < ApplicationController
  def index
    sort_by = params[:sort_by] || 'created_at'
    order = (params[:order] || 'desc').downcase
    @tasks = Task.order("#{sort_by} #{order}")
  end

  def new 
    @new_task = Task.new
  end

  def create
    @new_task = Task.new(task_params)
    if @new_task.save
      redirect_to tasks_path, notice: 'New task was created successfully!'
    else
      render :new
    end
  end

  def show
    @task = find_task(params[:id])
  end

  def edit
    @task = find_task(params[:id])
  end

  def update
    @task = find_task(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Edit task successfully!'
    else
      render :edit
    end

  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path, notice: 'Deleted task successfully!'
  end

  private 
  def find_task(id)
    Task.find(id)
  end

  def task_params
    params.require(:task).permit(:title, :description, :due)
  end
end
