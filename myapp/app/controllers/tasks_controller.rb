class TasksController < ApplicationController
  before_action :login_check, :set_menu

  # 一覧
  def index
    @search_form = params.key?(:search_form) ? SearchForm.new(permitted_search_params) : SearchForm.new
    @tasks = login_user.searched_tasks(@search_form, params[:page])
  end

  # 新規作成画面
  def new
    @task = login_user.tasks.build
  end

  # 新規作成実行
  def create
    @task = login_user.tasks.build(permitted_params)
    if @task.save
      redirect_to tasks_path, notice: t('messages.create.notice')
    else
      render action: :new
    end
  end

  # 編集画面表示
  def edit
    @task = target_task
  end

  # 更新
  def update
    @task = target_task

    if @task.update(permitted_params)
      redirect_to tasks_path, notice: t('messages.update.notice')
    else
      render action: :edit
    end
  end

  # 削除
  def destroy
    target_task.destroy
    redirect_to tasks_path, notice: t('messages.destroy.notice')
  end

  private

  # idでtask取得
  def target_task
    Task.find(params[:id])
  end

  # ストロングパラメータをとる
  def permitted_params
    params.require(:task).permit(:name, :description, :due_date, :status, label_ids: [])
  end

  # ストロングパラメータをとる(検索)
  def permitted_search_params
    params.require(:search_form).permit(:name, :status, :sort, :order, label_ids: [])
  end
end
