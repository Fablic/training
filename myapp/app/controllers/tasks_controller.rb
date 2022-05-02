class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.new(task_params)
    # TODO：ステップ16: 複数人で利用できるようにしよう（ユーザの導入）時に合わせて修正
    # 現段階ではユーザーは考慮しないので、NOT NULL制約回避用にダミーデータ格納
    @task.user_id = 0

    return unless @task.save

    redirect_to @task, notice: 'タスクを作成しました。'
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    return unless @task.update_attributes(task_params)

    redirect_to @task, notice: 'タスクを更新しました。'
  end

  def destroy
    @task = Task.find(params[:id])
    return unless @task.destroy
    
    redirect_to tasks_path, notice: 'タスクを削除しました。'
  end

  private

    def task_params
      params.require(:task).permit(:user_id, :title, :description, :termination_at, :priority, :status)
    end
end
