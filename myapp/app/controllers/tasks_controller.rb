class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :get_users, only: [:new, :edit]
  before_action :check_current_user, only: [:edit, :destroy]

  def index
    @tasks = current_user.tasks.eager_load(:user).includes([:labels]).includes([:labellings]).all.page(params[:page])
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
    @tasks = current_user.tasks.eager_load(:user).includes([:labellings]).name_like(params[:name]).status_equal(Task.statuses[params[:status]]).page(params[:page])
    @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
    render :index
  end

  private

  def task_params
    params.require(:task).permit(:name, :detail, :status, :priority, { label_ids: [] })
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def get_users
    @users = User.all
  end

  def check_current_user
    current_user.tasks.find(params[:id])
  end
end
