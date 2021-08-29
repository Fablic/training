# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task_by_id, only: %i[show edit update destroy]
  def index # rubocop:disable Metrics/AbcSize
    @tasks = Task.sort_column_direction(params[:sort], params[:direction])
      .search_name(params[:keyword_name]).search_progress(params[:keyword_progress])
      .page(params[:page]).per(10)
    @keyword_name = params[:keyword_name]
    @keyword_progress = params[:keyword_progress]
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = I18n.t 'tasks.flash.create.success'
      redirect_to @task
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t 'tasks.flash.update.success'
      redirect_to @task
    end
  end

  def destroy
    @task.destroy

    flash[:success] = I18n.t 'tasks.flash.destroy.success'
    redirect_to tasks_path
  end

  private

  def set_task_by_id
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :priority, :progress)
  end
end
