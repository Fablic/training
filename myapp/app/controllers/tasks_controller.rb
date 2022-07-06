# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.sortby(params[:sort], params[:direction])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = I18n.t('tasks.flash.create.success')
      redirect_to @task
    else
      flash.now[:error] = I18n.t('tasks.flash.create.error')
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('tasks.flash.update.success')
      redirect_to @task
    else
      flash.now[:error] = I18n.t('tasks.flash.update.error')
      render :edit
    end
  end

  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = I18n.t('tasks.flash.destroy.success')
    else
      flash[:error] = I18n.t('tasks.flash.destroy.error')
    end
    redirect_to tasks_path
  end

  def search
    tasks = Task.sortby(params[:sort], params[:direction])
    tasks = tasks.name_or_description(params[:keyword])
    tasks = tasks.status(params[:status])

    @tasks = tasks
    render 'index'
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :priority, :status, :limit).merge(user_id: 1)
  end
end
