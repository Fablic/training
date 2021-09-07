# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task_by_id, only: %i[show edit update destroy]
  before_action :confirm_permission, only: %i[show edit update destroy]

  def index # rubocop:disable Metrics/AbcSizeå
    @tasks = Task.includes(:labels).search_user_id(session[:user_id])
      .sort_column_direction(params[:sort], params[:direction])
      .search_name(params[:keyword_name]).search_progress(params[:keyword_progress])
      .search_label_id(params[:label_id])
      .page(params[:page]).per(10)

    @keyword = { "name" => params[:keyword_name], "progress" => params[:keyword_progress], "label_id" => params[:label_id] }
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @user = current_user

    @task = @user.tasks.build(task_params)

    return unless @task.save

    flash[:success] = I18n.t('controllers.flash.success', model: Task.model_name.human, action: I18n.t('controllers.action.create'))
    redirect_to @task
  end

  def edit
  end

  def update
    return unless @task.update(task_params)

    flash[:success] = I18n.t('controllers.flash.success', model: Task.model_name.human, action: I18n.t('controllers.action.update'))
    redirect_to @task
  end

  def destroy
    @task.destroy

    flash[:success] = I18n.t('controllers.flash.success', model: Task.model_name.human, action: I18n.t('controllers.action.destroy'))
    redirect_to tasks_path
  end

  private

  def set_task_by_id
    @task = Task.includes(:labels).find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :priority, :progress, { label_ids: [] })
  end

  def confirm_permission
    return if permitted?(@task.user_id)

    flash[:danger] = I18n.t 'sessions.flash.permission.denied'
    redirect_back(fallback_location: root_path)
  end
end
