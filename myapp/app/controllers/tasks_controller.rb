# frozen_string_literal: true

class TasksController < ApplicationController

  def index
    # タスク一覧オブジェクト取得
    @tasks = login_user.tasks.preload(:labels).where(id: login_user.tasks.get_ids(params[:title], params[:label], params[:status])).order('tasks.created_at desc').page(params[:page])
  end

  def show
    @task = login_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = login_user.tasks.find(params[:id])
  end

  def create
    @task = login_user.tasks.new(task_params)

    if @task.save
      redirect_to(root_path, notice: 'タスクを登録しました')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    @task = login_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to(root_path, notice: 'タスク更新成功')
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @task = login_user.tasks.find(params[:id])
    redirect_to(root_path, notice: 'タスク削除成功') if @task.destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, { label_ids: [] })
  end
end
