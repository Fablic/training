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

    if @task.save
      flash[:success] = 'タスク投稿が成功しました'
      redirect_to @task
    else
      flash[:danger] = 'タスク投稿が失敗しました'
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'タスク編集が成功しました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスク編集が失敗しました'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path
  end
end

def task_params
  params.require(:task).permit(:title, :content)
end
