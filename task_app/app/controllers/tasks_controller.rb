# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[edit update destroy]

  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to root_url, flash: { success: create_flash_message('create', 'success') }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_url, flash: { success: create_flash_message('update', 'success') }
    else
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      redirect_to root_url, flash: { success: create_flash_message('destroy', 'success') }
    else
      redirect_to root_url, flash: { danger: create_flash_message('destroy', 'failed') }
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def create_flash_message(action, result)
    I18n.t("flash.#{result}", target: "#{Task.model_name.human}「#{@task.name}」", action: I18n.t("actions.#{action}"))
  end
end
