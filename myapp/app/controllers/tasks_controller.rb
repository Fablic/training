class TasksController < ApplicationController
  before_action :fetch_task_by_params_id, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    # TODO: add validation to Task model
    if @task.save
      flash[:success] = 'Task successfully created'
      redirect_to @task
    else
      flash[:error] = 'Something went wrong'
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task was successfully updated'
      redirect_to @task
    else
      flash[:error] = 'Something went wrong'
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = 'Task was successfully deleted.'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to tasks_url
  end

  private

  def fetch_task_by_params_id
    @task = Task.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :deadline_at)
  end
end
