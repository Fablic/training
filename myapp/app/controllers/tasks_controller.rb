# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :logged_in_user

  def index
    @conditions = params || {}
    @tasks = @current_user.tasks.search(@conditions)
  end

  def show
    @task = @current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = @current_user.tasks.new(task_params)

    if @task.save
      flash[:success] = I18n.t('tasks.new.messages.success')
      redirect_to @task
    else
      flash.now[:danger] = I18n.t('tasks.new.messages.error')
      render :new
    end
  end

  def edit
    @task = @current_user.tasks.find(params[:id])
  end

  def update
    @task = @current_user.tasks.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('tasks.edit.messages.success')
      redirect_to @task
    else
      flash.now[:danger] = I18n.t('tasks.edit.messages.error')
      render :edit
    end
  end

  def destroy
    @task = @current_user.tasks.find(params[:id])

    if @task.destroy
      flash[:success] = I18n.t('tasks.destroy.messages.success')
      redirect_to root_path
    else
      flash[:danger] = I18n.t('tasks.destroy.messages.error')
      redirect_to request.url
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :end_date, :status)
  end
end
