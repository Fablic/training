# frozen_string_literal: true

class TasksController < ApplicationController # rubocop:disable Style/Documentation
  rescue_from StandardError, with: :render_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def show
    ## show
  end

  def edit
    ## edit
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1
    if @task.save
      flash[:info] = I18n.t('tasks.create_success')
      redirect_to @task
    else
      flash[:warn] = I18n.t('tasks.create_failure')
      render :new
    end
  end

  def update
    if @task.update(task_params)
      flash[:info] = I18n.t('tasks.update_success')
      redirect_to @task
    else
      flash[:warn] = I18n.t('tasks.update_failure')
      render :edit
    end
  end

  def destroy
    if @task.delete
      flash[:info] = I18n.t('tasks.delete_success')
    else
      flash[:warn] = I18n.t('tasks.delete_failure')
    end
    redirect_to tasks_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end

  def render_not_found
    render file: Rails.root.join('public/404.html'), status: :not_found
  end

  def render_internal_server_error(exception)
    logger.error(exception.message)
    logger.error(exception.backtrace.join("\n"))

    render file: Rails.root.join('public/500.html'), status: :internal_server_error
  end
end
