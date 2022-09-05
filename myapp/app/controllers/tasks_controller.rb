class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.eager_load(:user).all.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @task = Task.new
    @users = User.all
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @users = User.all
  end

  def update
    if @task.update(task_params)
      redirect_to task_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
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
