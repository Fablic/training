# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
      @tasks = Task.where_user_id(login_user.id).where_title(params[:title]).where_label(params[:label]).where_status(params[:status])
      @tasks = Task.where(id: @tasks.map { |t| t.id }).order('tasks.created_at desc').page(params[:page])
  end

  def show
    @task = Task.eager_load(:labels).find(params[:id])
    @label1 = @task.labels[0].name if @task.labels.size > 0
    @label2 = @task.labels[1].name if @task.labels.size > 1
    @label3 = @task.labels[2].name if @task.labels.size > 2
    @label4 = @task.labels[3].name if @task.labels.size > 3
    @label5 = @task.labels[4].name if @task.labels.size > 4
  end

  def new
    @task_form = TaskForm.new
    @is_status = false
  end

  def edit
    @task = Task.find(params[:id])
    @is_status = true
    @task_form = TaskForm.new
    @task_form.setting(params[:id])
  end

  def create
    @task_form = TaskForm.new(task_params)

    if @task_form.save
      redirect_to(root_path, notice: 'タスクを登録しました')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    @task_form = TaskForm.new(task_params)

    if @task_form.update(params[:id])
      redirect_to(root_path, notice: 'タスクを更新しました')
    else
      @task = Task.find(params[:id])
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を削除しました。"
    else
      render :show
    end
  end

  private

  def task_params
    params.require(:task_form)[:user_id] = login_user.id
    params.require(:task_form).permit(:title, :description, :label1, :label2, :label3, :label4, :label5, :user_id, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
