class TasksController < ApplicationController
  def index
    @tasks = Task.order(due: :desc)
  end

  def new 
    @new_task = Task.new
  end

  def create
    @new_task = Task.new(params.require(:task).permit(:title, :description, :due))
    if @new_task.save
      redirect_to tasks_path, success: 'New task was created successfully!'
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
    if @task.update(params.require(:task).permit(:title, :description, :due))
      redirect_to tasks_path, notice: 'Edit task successfully!'
    else
      render :edit
    end

  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:alert] = 'Deleted task successfully!'
    redirect_to tasks_path
  end

  private 
  def find_task(id)
    Task.find(id)
  end
end
