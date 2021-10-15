class TasksController < ApplicationController
  before_action :set_menu

  # 一覧
  def index
    @search_form = params.key?(:search_form) ? SearchForm.new(permitted_search_params) : SearchForm.new
    @tasks = @search_form.exec_search(params[:page])
  end

  # 新規作成画面
  def new
    @task = Task.new
  end

  # 新規作成実行
  def create
    @task = Task.new(permitted_params)
    @task.user_id = 1 # 次ステップでログインユーザーIDが入ります。
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
    @task = target_task
  end

  # 更新
  def update
    @task = target_task

    if @task.update(permitted_params)
      # 一覧へ
      redirect_to tasks_path, notice: t('messages.update.notice')
    else
      # 編集画面へ
      render action: :edit
    end
  end

  # 削除
  def destroy
    target_task.destroy

    # 一覧へ
    redirect_to tasks_path, notice: t('messages.destroy.notice')
  end

  # private methods

  private

  # idでtask取得
  def target_task
    Task.find(params[:id])
  end

  # ストロングパラメータをとる
  def permitted_params
    params.require(:task).permit(:name, :description, :due_date, :status)
  end

  # ストロングパラメータをとる(検索)
  def permitted_search_params
    params.require(:search_form).permit(:name, :status, :sort, :order)
  end

  # menuをセットする
  def set_menu
    @menus = [
      Menu.new(t('.menu.btn_list'), tasks_path),
      Menu.new(t('.menu.btn_add'), new_task_path)
    ]
  end
end
