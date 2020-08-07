# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @order_by = sort_direction
    @tasks = Task.find_pj_tasks(@project)
             .order_finished_at(@order_by)
             .order(created_at: :desc)
  end

  def show
  end

  def new
    @users = User.all
    @task = Task.new
    @project = Project.find(params[:project_id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '作成')
    else
      flash[:error] = @task.errors.full_messages.join(',')
      redirect_to new_task_path(project_id: task_params[:project_id])
    end
  end

  def edit
    @users = User.all
    @project = @task.project
  end

  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '更新')
      redirect_to @task
    else
      flash[:error] = @task.errors.full_messages.join(',')
      redirect_to edit_task_path(project_id: task_params[:project_id])
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '削除')
    else
      flash[:error] = I18n.t('flash.failed', model: 'タスク', action: '削除')
    end
    redirect_to tasks_path(project_id: @task.project_id)
  end

  private

  def sort_direction
    %w[asc desc].include?(params[:order_by]) ? params[:order_by] : nil
  end

  private

  def not_found
    render_404(e)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at)
  end
end
