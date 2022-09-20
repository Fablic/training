# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    query = Task.all
    query = query.sort_by_keyword(search_params[:sort]) if search_params[:sort].present?
    query = query.search_keyword(search_params[:keyword]) if search_params[:keyword].present?
    query = query.search_status(search_params[:status]) if search_params[:status].present?
    query = query.page(search_params[:page])

    @tasks = query
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to task_url(@task),
                  notice: I18n.t('messages.create', model_name: I18n.t('activerecord.models.task'))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task),
                  notice: I18n.t('messages.update', model_name: I18n.t('activerecord.models.task'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to tasks_url, notice: I18n.t('messages.destroy', model_name: I18n.t('activerecord.models.task'))
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :end_date, :priority, :status, :explanation)
  end

  def search_params
    params.permit(:page, :keyword, :status, :sort)
  end
end
