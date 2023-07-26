class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
    @labels = @task.labels
  end

  def new
    @task = Task.new
    @labels = Label.all
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1
    if @task.save
      flash[:success] = "Task was successfully created."
      redirect_to task_path(@task)
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
    @labels = Label.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "Task was successfully updated."
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = "Task was successfully deleted."
    redirect_to root_path, status: 303
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :deadline, :status, :user_id, label_ids: [])
  end
end
