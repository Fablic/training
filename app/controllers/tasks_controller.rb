# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.order(updated_at: :desc)
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('tasks.flash.create.success')
      redirect_to root_path
    else
      flash.now[:danger] = t('tasks.flash.create.danger')
      render 'new'
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = t('tasks.flash.update.success')
      redirect_to root_path
    else
      flash.now[:danger] = t('tasks.flash.update.danger')
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('tasks.flash.destroy.success')
    else
      flash[:danger] = t('tasks.flash.destroy.danger')
    end
    redirect_to root_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
