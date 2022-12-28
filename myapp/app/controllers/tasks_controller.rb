class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = task_find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(get_task_params)
    if @task.save
      redirect_to tasks_path, flash: {success: "登録が完了しました"}
    else
      flash.now[:alert] = "必須項目を埋めてください"
      render :new
    end
  end

  def edit
    @task = task_find(params[:id])
  end

  def update
    @task = task_find(params[:id])
    if @task.update(get_task_params)
      redirect_to tasks_path, flash: {success: "更新が完了しました"}
    else
      flash.now[:alert] = "必須項目を埋めてください"
      render :edit
    end
  end

  def destroy
    @task = task_find(params[:id])
    @task.destroy
    redirect_to tasks_path, flash: {success: "タスクを削除しました"}
  end

  private

  def task_find(task_id)
    return Task.find(task_id)
  end

  def get_task_params
    task_params = params.require(:task).permit(:title, :content, :priority, :status, :due_date)
    # 後ほど外部参照で取得できるようにする
    task_params["user_id"] = 1
    task_params["tag_id"] = 1
    return task_params
  end

end
