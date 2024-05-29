# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :require_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  TASKS_PER_PAGE = 5

  def index
    @tasks = Task.all.includes([:user])
    @tasks = @tasks.filter_status(params[:status]) if params[:status].present?
    @tasks = @tasks.search_title(params[:search]) if params[:search].present?

    # For sorting function
    if params[:sort].presence_in(Task.column_names)
      sort_column = params[:sort]
      sort_direction = params[:is_order_desc] == "true" ? "DESC" : "ASC"
    else
      sort_column = "created_at"
      sort_direction = "DESC"
    end
    @tasks = @tasks.order("#{sort_column} #{sort_direction}")

    # For pagination
    @tasks = @tasks.page(params[:page]).per(TASKS_PER_PAGE)
  end

  def new
    @task = Task.new
  end

  def show
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t("tasks.create.notice")
    else
      render :new, alert: t("tasks.create.alert")
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("tasks.update.notice")
    else
      render :edit, alert: t("tasks.update.alert")
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, notice: t("tasks.delete.notice")
    else
      redirect_to tasks_path, alert: t("tasks.delete.alert")
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :expiration_date, :status, :user_id)
    end
end
