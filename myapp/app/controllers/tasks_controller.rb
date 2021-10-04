class TasksController < ApplicationController
  # helperでも使用可能
  helper_method :sort_column, :sort_type

  # 一覧
  def index
    @tasks = Task.all.order("#{sort_column} #{sort_type}")
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
      redirect_to tasks_path, notice: t('messages.create.notice')
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
      redirect_to tasks_path, notice: t('messages.update.notice')
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
    redirect_to tasks_path, notice: t('messages.destroy.notice')
  end

  # private methods

  private

  # idでtask取得
  def find_by_id
    Task.find(params[:id])
  end

  # フォーム内容をオブジェクトにセット
  def set_params_to_task
    params.require(:task).permit(:name, :description, :period_date)
  end

  # sortの方式をとる
  def sort_type
    %w[asc desc].include?(params[:type]) ? params[:type] : 'desc'
  end

  # sort対象のカラム
  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
