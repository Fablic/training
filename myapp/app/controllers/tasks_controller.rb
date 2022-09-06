class TasksController < ApplicationController
  # Task List
  def index
    @tasks = Task.all
  end

  # Show Task
  def show
    @task =Task.find(params[:id])
  end

  # New Task
  def new
    @task = Task.new

    # UserNames
#    @user_names = user_names
  end

  # New Task → Create Task
  def create
    @task = Task.new(task_params)
    @task.user_id = 1

    if @task.save
      redirect_to(tasks_url, notice: 'Create Task Success!!')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Edit Task
  def edit
    @task = Task.find(params[:id])

    # 担当者名リスト取得
#    @user_names = user_names
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
    @tasks = Task.where_title(params[:title]).where_status(Task.statuses[params[:status]])
    render :index
  end

  private

  # Get Task Parameter
  def task_params
    task = params.require(:task).permit(:title, :description, :label, :status)
  end

  # Get UserNames
#  def user_names
#    user_names = []
#    users = User.all.select('users.id, users.name')
#    users.each do |user|
#      user_names.push([user.name, user.id])
#    end
#    user_names
#  end

end
