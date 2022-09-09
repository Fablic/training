# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # bullet worningが発生するため"eager_load(:labels)"を記載
    @tasks = login_user.tasks.eager_load(:labels).where_title(params[:title]).where_status(params[:status]).where_label(params[:label])
    @tasks = Task.where(id: @tasks.map { |t| t.id }).order('tasks.created_at desc').page(params[:page])
  end

  # タスク作成画面
  def new
    @task_form = TaskForm.new
    @is_status = false
  end

  # タスク作成画面
  def create
    create_params = task_params
    create_params[:user_id] = login_user.id
    @task_form = TaskForm.new(create_params)

    if @task_form.save
      redirect_to(root_path, notice: 'タスク作成成功')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # タスク詳細画面
  def show
    @task = login_user.tasks.find(params[:id])
    if @task.labels.present?
      @label1 = @task.labels[0].name if @task.labels.size > 0
      @label2 = @task.labels[1].name if @task.labels.size > 1
      @label3 = @task.labels[2].name if @task.labels.size > 2
      @label4 = @task.labels[3].name if @task.labels.size > 3
      @label5 = @task.labels[4].name if @task.labels.size > 4
    end
  end

  # タスク編集画面
  def edit
    @task = login_user.tasks.find(params[:id])
    @is_status = true
    @task_form = TaskForm.new
    @task_form.setting(@task.id)
  end

  # タスク更新
  def update
    create_params = task_params
    create_params[:user_id] = login_user.id
    @task_form = TaskForm.new(create_params)
    task = login_user.tasks.find(params[:id])

    if @task_form.update(task.id)
      redirect_to(root_path, notice: 'タスク更新成功')
    else
      @task = login_user.tasks.find(params[:id])
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
    params.require(:task_form).permit(:title, :content, :label1, :label2, :label3, :label4, :label5, :user_id, :status)
  end
end
