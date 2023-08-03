class TaskController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
    @labels = Label.all
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1
    @task.user_type = 'Task'
    if @task.save
      flash[:success] = "Task was successfully created."
      redirect_to task_index_path(@task)
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
    # @labels = @task.labels
  end

  def edit
    @task = Task.find(params[:id])
    # @labels = Label.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "Task updated."
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = "Task deleted."
    redirect_to task_index_path, status: 303
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :due_date, :status, :user_id, :assigned_user_id, )
  end

end
