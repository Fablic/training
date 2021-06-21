# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(create_sort_query)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = I18n.t(:'message.registered_task')
      redirect_to root_path
    else
      flash[:error] = I18n.t(:'message.registered_is_failed')
      render :new
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.update(task_params)
      flash[:success] = I18n.t(:'message.edited_task')
      redirect_to root_path
    else
      flash[:error] = I18n.t(:'message.edited_is_faild')
      render :edit
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task.delete

    flash[:success] = I18n.t(:'message.deleted_task')
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :end_at)
  end

  def create_sort_query
    return { end_at: :asc } if params[:end_at] == 'asc'
    return { end_at: :desc } if params[:end_at] == 'desc'

    { created_at: :desc }
  end
end
