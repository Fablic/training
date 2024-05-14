class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    
  end

  def create
    @new_task = Task.new(params.require(:task).permit(:title, :description))
    @new_task.save

    redirect_to action: "index"
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
  end
end
