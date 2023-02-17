class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    # TODO: use strong parameters
    task_params = params[:task]
    @task = Task.new(name: task_params[:name], description: task_params[:description], deadline_at: task_params[:deadline_at])
    if @task.save
      flash[:success] = "Task successfully created"
      redirect_to @task
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
