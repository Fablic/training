class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1
    if @task.save
      flash[:info] = 'タスクの作成に成功しました。'
      redirect_to @task
    else
      flash[:warn] = 'タスクの作成に失敗しました。'
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    if task.update(task_params)
      flash[:info] = 'タスクの更新に成功しました。'
      redirect_to task
    else
      flash[:warn] = 'タスクの更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    if task.delete
      flash[:info] = 'タスクの削除に成功しました。'
    else
      flash[:warn] = 'タスクの削除に失敗しました。'
    end
    redirect_to task
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end
end
