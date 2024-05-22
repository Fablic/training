class TasksController < ApplicationController
  def index
    @tasks = Task.order(due: :desc)
  end

  def new; end

  def create
    @new_task = Task.new(params.require(:task).permit(:title, :description))
    @new_task.save

    flash[:success] = 'New task was created successfully!'
    redirect_to tasks_path
  end

  def show
    @task = find_task(params[:id])
  end

  def edit
    @task = find_task(params[:id])
  end

  def update
    @task = find_task(params[:id])
    @task.update(params.require(:task).permit(:title, :description))

    flash[:notice] = 'Edit task successfully!'
    redirect_to tasks_path
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
