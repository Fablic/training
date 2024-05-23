# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    session[:is_order_desc] = session[:is_order_desc].nil? ? true : !session[:is_order_desc]
    sort_column = params[:sort].presence_in(Task.column_names) ? params[:sort] : 'created_at'
    sort_direction = session[:is_order_desc] ? 'DESC' : 'ASC'
    @tasks = Task.order("#{sort_column} #{sort_direction}")
    @tasks
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
      params.require(:task).permit(:title, :description, :expiration_date)
    end
end
