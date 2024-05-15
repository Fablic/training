class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new; end

  def create
    @new_task = Task.new(params.require(:task).permit(:title, :description))
    @new_task.save

    flash[:success] = 'New task was created successfully!'
    redirect_to action: 'index'
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update(params.require(:task).permit(:title, :description))

    flash[:notice] = 'Edit task successfully!'
    redirect_to action: 'index'
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:alert] = 'Deleted task successfully!'
    redirect_to action: 'index'
  end
end
