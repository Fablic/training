# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.where(deleted: 0).order(due_date_at: :desc)
  end

  def new
    @task = Task.new
    @submit_label = I18n.t('dictionary.words.save_to_create')
  end

  def edit
    @task = Task.find_by(id: params[:id], deleted: 0)
    @submit_label = I18n.t('dictionary.words.save_to_update')
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.edited_task')
    else
      render edit, notice: I18n.t('dictionary.messages.edited_task_failed')
    end
  end

  def show
    id = params[:id]
    @task = Task.find_by(id: id, deleted: 0)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.created_task')
    else
      render new, notice: I18n.t('dictionary.messages.created_task_failed')
    end
  end

  def destroy
    @task = Task.find(params[:id])
    flash[:notice] = if @task.update(deleted: 1)
                       I18n.t('dictionary.messages.deleted_task')
                     else
                       I18n.t('dictionary.messages.deleted_task_failed')
                     end

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :start_at, :due_date_at)
  end
end
