class TasksController < ApplicationController
  # 一覧
  def index
    @tasks = Task.all
  end

  # 新規作成画面
  def new
    @task = Task.new
  end

  # 新規作成実行
  def create
    @task = Task.new(set_params_to_task)

    if @task.save
      # 一覧へ
      redirect_to tasks_path, notice: t("messages.create.notice")
    else
      # 登録画面へ
      render action: :new
    end
  end

  # 編集画面表示
  def edit
    @task = find_by_id
  end

  # 更新
  def update
    @task = find_by_id

    if @task.update(set_params_to_task)
      # 一覧へ
      redirect_to tasks_path, notice: t("messages.update.notice")
    else
      # 編集画面へ
      render action: :edit
    end
  end

  # 削除
  def destroy
    @task = find_by_id
    @task.destroy

    # 一覧へ
    redirect_to tasks_path, notice: t("messages.destroy.notice")
  end

  # private methods

  private

  def find_by_id
    Task.find(params[:id])
  end

  def set_params_to_task
    params.require(:task).permit(:name, :description)
  end
end
