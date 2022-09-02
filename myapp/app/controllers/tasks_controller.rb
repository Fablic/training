# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # タスク一覧オブジェクト取得
    if params && (params[:word].present? || params[:status].present?)
      @tasks = Task.includes(:labels).where_user_id(login_user.id).where_title(params[:title]).where_status(params[:status]).order('tasks.created_at desc').page(params[:page])
    else
      @tasks = Task.includes(:labels).where_user_id(login_user.id).order('tasks.created_at desc').page(params[:page])
    end
  end

  # タスク作成画面
  def new
    @task = Task.new
    @is_status = false
  end

  # タスク作成画面
  def create
    @task_form = TaskForm.new(task_params)

    if @task_form.save
      redirect_to(root_path, notice: 'タスク作成成功')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # タスク詳細画面
  def show
    @task = Task.includes(:labels).find(params[:id])
    @label1 = @task.labels[0].name if @task.labels.size > 0
    @label2 = @task.labels[1].name if @task.labels.size > 1
    @label3 = @task.labels[2].name if @task.labels.size > 2
    @label4 = @task.labels[3].name if @task.labels.size > 3
    @label5 = @task.labels[4].name if @task.labels.size > 4
  end

  # タスク編集画面
  def edit
    @task = Task.find(params[:id])
    @is_status = true
    @task_form = TaskForm.new
    @task_form.setting(params[:id])
  end

  # タスク更新
  def update
    @task_form = TaskForm.new(task_params)

    if @task_form.update(params[:id])
      redirect_to(root_path, notice: 'タスク更新成功')
    else
      @task = Task.find(params[:id])
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
    params.require(:task_form)[:user_id] = login_user.id
    params.require(:task_form).permit(:title, :content, :label1, :label2, :label3, :label4, :label5, :user_id, :status)
  end
end
