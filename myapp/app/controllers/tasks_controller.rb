# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = if params[:latest]
               Task.latest
             else
               Task.all
             end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = I18n.t('tasks.new.messages.success')
      redirect_to @task
    else
      flash.now[:danger] = I18n.t('tasks.new.messages.error')
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('tasks.edit.messages.success')
      redirect_to @task
    else
      flash.now[:danger] = I18n.t('tasks.edit.messages.error')
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

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
    params.require(:task).permit(:title, :description)
  end
end
