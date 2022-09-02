# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # タスク一覧オブジェクト取得
    # user対応コメントアウト
    # @tasks = Task.joins(:user).all
    if params && (params[:title].present? || params[:status].present?)
      @tasks = Task.where_title(params[:title]).where_status(params[:status]).order('tasks.created_at desc').page(params[:page]).per(5)
    else
      @tasks = Task.all.order('tasks.created_at desc').page(params[:page]).per(5)
    end
  end

  # タスク作成画面
  def new
    @task = Task.new
    @is_status = false

    # # 担当者名リスト取得
    # user対応コメントアウト
    # @select_user_names = []
    # users = User.all
    # users.each do |user|
    #   @select_user_names.push([user.name, user.id])
    # end
  end

  # タスク作成画面
  def create
    @task = Task.new(task_params)
    # user対応コメントアウトのためID決め打ち
    @task.user_id = 1

    if @task.save
      redirect_to(root_path, notice: 'タスク作成成功')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # タスク詳細画面
  def show
    # user対応コメントアウト
    # @task = Task.joins(:user).find(params[:id])
    @task = Task.find(params[:id])
  end

  # タスク編集画面
  def edit
    @task = Task.find(params[:id])
    @is_status = true

    # user対応コメントアウト
    # # 担当者名リスト取得
    # @select_user_names = []
    # users = User.all
    # users.each do |user|
    #   @select_user_names.push([user.name, user.id])
    # end

  end

  # タスク更新
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to(root_path, notice: 'タスク更新成功')
    else
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
    # user対応コメントアウトのためID決め打ち
    # task_params[:user_id] = task_params[:user_id].to_i
    task_params[:user_id] = 1

    task_params
  end
end
