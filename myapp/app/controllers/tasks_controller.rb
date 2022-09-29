class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :get_users, only: [:new, :edit]
  before_action :create_empty_task, only: [:index, :new, :search]

  def index
    @tasks = current_user.tasks.includes([:labellings, :labels]).includes(:labels).all.page(params[:page])
  end

  def show; end

  def new; end

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
    @tasks = current_user.tasks.search(search_params).page(params[:page])
    render :index
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :priority, { label_ids: [] })
  end

  def search_params
    params.require(:task).permit(:name, :status, :label_id)
  end

  def get_users
    @users = User.all
  end

  def create_empty_task
    @task = Task.new
  end
end
