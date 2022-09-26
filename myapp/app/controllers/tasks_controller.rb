class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :get_users, only: [:new, :edit]

  def index
    @tasks = current_user.tasks.eager_load(:user).all.page(params[:page])
  end

  def show; end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit; end

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
    @tasks = current_user.tasks.eager_load(:user).name_like(params[:name]).status_equal(Task.statuses[params[:status]]).page(params[:page])
    render :index
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :priority, :user_id)
  end

  def get_users
    @users = User.all
  end

end
