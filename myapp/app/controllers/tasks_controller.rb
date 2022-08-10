class TasksController < ApplicationController
  # Task List
  def list
    @tasks = Task.all
  end

  # Show Task
  def show
    @show_task =Task.joins(:user).select('tasks.title, tasks.description, tasks.label, users.name, tasks.status').where(id: params[:id]).first
  end

  # New Task
  def new
    @task = Task.new

    # UserNames
    @user_names = user_names
  end

  # New Task → Create Task
  def create
    @task = Task.new(task_params)
    @task.update_attributes(task_params[:task]) unless task_params[:task].blank?

    respond_to do |format|
      if @task.save
        format.html { redirect_to('/', notice: 'Create Task Success!!') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # Edit Task
  def edit
    @task = Task.find(params[:id])

    # 担当者名リスト取得
    @user_names = user_names

    # 状況リスト取得
    @statuses = status

    puts @user_names
  end

  # Edit Task → Update Task
  def update
    @task = Task.find(params[:id])
    
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to '/', notice: "Update Task Success!!" }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # Destroy Task
  def destroy
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.destroy
        format.html { redirect_to('/', notice: 'Destroy Task Success!!') }
        format.json { head :no_content }
      end
    end
  end

  private

  # Get Task Parameter
  def task_params
    task = params.require(:task).permit(:title, :description, :label, :user_id, :status)
    task[:user_id] = task[:user_id].to_i
    task
  end

  # Get UserNames
  def user_names
    user_names = []
    users = User.all.select('users.id, users.name')
    users.each do |user|
      user_names.push([user.name, user.id])
    end
    user_names
  end

  # Get Statuses
  def statuses
    statuses = []
    Task::STATUS_VIEW.each do |key, value|
      statuses.push([value, key])
    end
    statuses
  end
end
