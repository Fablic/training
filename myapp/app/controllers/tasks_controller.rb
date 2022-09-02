class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.eager_load(:user).all.page(params[:page]).per(5)
  end

  def show
    current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    current_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to task_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    current_user.tasks.find(params[:id])

    if @task.destroy
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
    else
      render :show
    end
  end

  def search
    @tasks = Task.eager_load(:user).name_like(params[:name]).status_equal(Task.statuses[params[:status]]).page(params[:page]).per(5)
    render :index
  end

  private

  def task_params
    params.require(:task).permit(:name, :detail, :status, :priority, :user_id)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
