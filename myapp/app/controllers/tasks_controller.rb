# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # タスク一覧オブジェクト取得
    # @tasks = Task.joins(:user).all
    if params && (params[:word].present? || params[:status].present?)
      @tasks = Task.search(params[:word], Task.statuses[params[:status]]).page(params[:page]).per(5)
    else
      @tasks = Task.joins(:user).all.order('tasks.created_at desc').page(params[:page]).per(5)
    end
  end

  # タスク作成画面
  def new
    @task = Task.new

    # 担当者名リスト取得
    @users_name = []
    User.all.each do |user|
      @users_name.push([user.name, user.id])
    end
  end

  # タスク作成画面
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to(root_path, notice: 'タスク作成成功')
    else
      render(:new)
    end

  end

  # タスク詳細画面
  def show
    @task = Task.joins(:user).find(params[:id])
  end

  # タスク編集画面
  def edit
    @task = Task.find(params[:id])

    # 担当者名リスト取得
    @users_name = []
    users = User.all
    users.each do |user|
      @users_name.push([user.name, user.id])
    end

  end

  # タスク更新
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to(root_path, notice: 'タスク更新成功')
    else
      render(:edit)
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

end
