# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[edit update destroy]

  def index
    @tasks = Task.search(params, current_user.tasks).order("#{params[:sort_column] || 'created_at'} #{params[:sort_direction] || 'desc'}").page(params[:page])
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to root_url, flash: { success: create_flash_message('create', 'success') }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_url, flash: { success: create_flash_message('update', 'success') }
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = create_flash_message('destroy', 'success')
    else
      flash[:danger] = create_flash_message('destroy', 'failed')
    end

    redirect_to root_url
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :due_date, :priority, :status)
  end

  def find_task
    @task = current_user.tasks.find(params[:id])
  end

  def create_flash_message(action, result)
    I18n.t("flash.#{result}", target: "#{Task.model_name.human}「#{@task.name}」", action: I18n.t("actions.#{action}"))
  end
end
