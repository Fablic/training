class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "Task was successfully created."
      redirect_to @task
    else
      flash.now[:alert] = "There was an error creating the task."
      render :new, status: 422
    end
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "Task was successfully updated."
      redirect_to @task
    else
      flash.now[:alert] = "There was an error updating the task."
      render :edit, status: 422
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "Task was successfully deleted."
    redirect_to tasks_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters.
  def task_params
    params.require(:task).permit(:name, :description, :user_id, :priority, :status, :deadline)
  end
end
