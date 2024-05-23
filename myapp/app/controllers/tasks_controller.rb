# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :require_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.where(user_id: session[:user_id]).order(created_at: :desc)
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
      params.require(:task).permit(:title, :description)
    end
end
