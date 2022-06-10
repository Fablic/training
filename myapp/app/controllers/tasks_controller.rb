class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def create
    @task = Task.new(params.require(:task).permit(:name, :description))

    if @task.save
      flash[:success] = 'Added new task'
      redirect_to @task
    else
      flash[:danger] = 'failed'
      render :new
    end
  end

  def new
    @task = Task.new()
  end

  def edit
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
