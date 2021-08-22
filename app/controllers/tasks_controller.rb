# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks.order(updated_at: :desc)
    @tasks = @tasks.by_name(params[:name]) if params[:name].present?
    @tasks = @tasks.by_status(params[:status]) if params[:status].present?
  end

  def show; end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = I18n.t('tasks.flash.create.success')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('tasks.flash.create.danger')
      render 'new'
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t('tasks.flash.update.success')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('tasks.flash.update.danger')
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = I18n.t('tasks.flash.destroy.success')
    else
      flash[:danger] = I18n.t('tasks.flash.destroy.danger')
    end
    redirect_to root_path
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status)
  end
end
