class TasksController < ApplicationController

  before_action :task_find, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
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
  end

  def update
    if @task.update(get_task_params)
      redirect_to tasks_path, flash: {success: "更新が完了しました"}
    else
      flash.now[:alert] = "必須項目を埋めてください"
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, flash: {success: "タスクを削除しました"}
  end

  private

  def task_find
    @task = Task.find(params[:id])
  end

  def get_task_params
    task_params = params.require(:task).permit(:title, :content, :priority, :status, :due_date)
    # 後ほど外部参照で取得できるようにする
    task_params["user_id"] = 1
    task_params["tag_id"] = 1
    return task_params
  end

end
