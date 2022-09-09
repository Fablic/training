class TasksController < ApplicationController
  # Task List
  def index
    @tasks = Task.includes(:user).all.page(params[:page])
  end

  # Show Task
  def show
    @task =Task.includes(:user).find(params[:id])
  end

  # New Task
  def new
    @task = Task.new
  end

  # New Task → Create Task
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to(tasks_url, notice: 'Create Task Success!!')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Edit Task
  def edit
    @task = Task.find(params[:id])
  end

  # Edit Task → Update Task
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to tasks_url, notice: 'Update Task Success!!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Destroy Task
  def destroy
    @task = Task.find(params[:id])

    if @task.destroy
      redirect_to(tasks_url, notice: 'Destroy Task Success!!')
    end
  end

  def search
    @tasks = Task.includes(:user).where_title(params[:title]).where_status(Task.statuses[params[:status]]).page(params[:page])
    render :index
  end

  private

  # Get Task Parameter
  def task_params
    task = params.require(:task).permit(:title, :description, :label, :status, :user_id)
  end
end
