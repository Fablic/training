# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # タスク一覧オブジェクト取得
    if params && (params[:title].present? || params[:status].present?)
      @tasks = Task.includes(:user).where_title(params[:title]).where_status(params[:status]).order('tasks.created_at desc').page(params[:page])
    else
      @tasks = Task.includes(:user).all.order('tasks.created_at desc').page(params[:page])
    end
  end

  # タスク作成画面
  def new
    @task = Task.new
    @is_status = false

    # 担当者名リスト取得
    @users_name = users_name
  end

  # タスク作成画面
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to(root_path, notice: 'タスク作成成功')
    else
      # 担当者名リスト取得
      @users_name = users_name
      render(:new, status: :unprocessable_entity)
    end

  end

  # タスク詳細画面
  def show
    @task = Task.includes(:user).find(params[:id])
  end

  # タスク編集画面
  def edit
    @task = Task.find(params[:id])
    @is_status = true

    # 担当者名リスト取得
    @users_name = users_name

  end

  # タスク更新
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to(root_path, notice: 'タスク更新成功')
    else
      # 担当者名リスト取得
      @users_name = users_name
      render(:edit, status: :unprocessable_entity)
    end
  end

  # タスク削除
  def destroy
    @task = Task.find(params[:id])

    redirect_to(root_path, notice: 'タスク削除成功') if @task.destroy
  end

  private

  # Taskパラメータ
  def task_params
    task_params = params.require(:task).permit(:title, :content, :label, :user_id, :status)
    task_params[:user_id] = task_params[:user_id]

    task_params
  end

  # ユーザー名リスト
  def users_name
    User.all.map { |k| [k.name, k.id] }
  end
end
