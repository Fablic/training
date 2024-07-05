# frozen_string_literal: true

class TasksController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_task_and_check_permissions, only: %i[show edit update destroy]

  MAX_LABEL_LENGTH = 3

  def index
    @tasks = search_tasks(search_params, current_user.id)
    @total_tasks_count = @tasks.count
    @tasks = @tasks.order("#{sort_column}  #{sort_direction}")
                   .page(params[:page]).per(5)
  end

  def new
    @task = Task.new
    build_labels(@task)
  end

  def show
    ## show
  end

  def edit
    build_labels(@task)
  end

  def create
    @task = Task.new(task_params)
    @task.labels_attributes = task_params[:labels_attributes]
    @task.user_id = current_user.id
    if @task.save
      # process_labels(@task, params[:task][:labels_attributes])
      flash[:notice] = I18n.t('tasks.create_success')
      redirect_to @task
    else
      flash.now[:alert] = I18n.t('tasks.create_failure')
      render :new
    end
  end

  def update
    @task.labels_attributes = task_params[:labels_attributes]
    if @task.update(task_params)
      flash[:notice] = I18n.t('tasks.update_success')
      redirect_to @task
    else
      flash.now[:alert] = I18n.t('tasks.update_failure')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t('tasks.delete_success')
    else
      flash[:alert] = I18n.t('tasks.delete_failure')
    end
    redirect_to tasks_path
  end

  private

  def set_task_and_check_permissions
    @task = Task.find(params[:id])
    return if current_user.admin? || current_user.id == @task.user_id

    @task = nil
    flash[:alert] = "You don't have permission to access this task"
    redirect_to tasks_path
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date, labels_attributes: [:id, :name, :_destroy])
    #params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? "tasks.#{params[:sort]}" : 'tasks.created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def search_params
    params.permit(:title, :status)
  end

  def search_tasks(params, user_id)
    Task.search(params[:title], params[:status], user_id)
  end

  def build_labels(task)
    (MAX_LABEL_LENGTH - task.labels.size).times { task.labels.build }
  end
end
