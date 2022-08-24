class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if params[:name].nil? && params[:status].nil?
      @tasks = Task.all
    else
      @tasks = Task.search(params[:name])
    end
  end

  def show
  end

  def new
    @task = Task.new
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

  private

  def task_params
    params.require(:task).permit(:name, :detail, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
