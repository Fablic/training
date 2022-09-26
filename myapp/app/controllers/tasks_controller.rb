# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :check_create_service, only: [:new, :create]
  before_action :check_update_service, only: [:edit, :update]
  before_action :check_delete_service, only: [:destroy]

  # タスク一覧画面
  def index
    @tasks = login_user.tasks.preload(:labels).where(id: login_user.tasks.get_ids(params[:title], params[:label], params[:status])).order('tasks.created_at desc').page(params[:page])
  end

  # タスク作成画面
  def new
    @task = Task.new
    @is_status = false
  end

  # タスク作成画面
  def create
    @task = Task.new(task_params)
    @task.user_id = login_user.id

    if @task.save
      redirect_to(root_path, notice: 'タスク作成成功')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # タスク詳細画面
  def show
    @task = login_user.tasks.find(params[:id])
  end

  # タスク編集画面
  def edit
    @task = login_user.tasks.find(params[:id])
    @is_status = true
  end

  # タスク更新
  def update
    @task = login_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to(root_path, notice: 'タスク更新成功')
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # タスク削除
  def destroy
    @task = login_user.tasks.find(params[:id])
    redirect_to(root_path, notice: 'タスク削除成功') if @task.destroy
  end

  private

  # Taskパラメータ
  def task_params
    params.require(:task).permit(:title, :content, :status, { label_ids: [] })
  end

  def check_create_service
    if Function.is_stopped(Function::FUNC_ID_CREATE)
      render(
        file: Rails.public_path.join("503.html"),
        content_type: "text/html",
        layout: false,
        status: :service_unavailable,
      )
    end
  end

  def check_update_service
    if Function.is_stopped(Function::FUNC_ID_UPDATE)
      render(
        file: Rails.public_path.join("503.html"),
        content_type: "text/html",
        layout: false,
        status: :service_unavailable,
      )
    end
  end

  def check_delete_service
    if Function.is_stopped(Function::FUNC_ID_DELETE)
      render(
        file: Rails.public_path.join("503.html"),
        content_type: "text/html",
        layout: false,
        status: :service_unavailable,
      )
    end
  end
end
