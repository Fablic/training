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

    return render 'new' unless @task.save

    # タスク作成を通知
    flash[:success] = 'Task created!'
    redirect_to root_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])

    # 異常系はearly return
    return render 'edit' unless task.update(task_params)

    # 正常系をmain blockに残す
    flash[:success] = 'Task updated!'
    redirect_to root_path
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = 'Task deleted!'
    redirect_to root_path
  end

  private

  def task_params
    # status, priorityはのちのstepで追加する
    params.require(:task).permit(:title, :description, :expire_at)
  end

end
