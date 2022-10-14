# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    query = Task.where(user_id: current_user.id).preload(:user, :task_labels, :labels)
    query = query.sort_by_keyword(search_params[:sort]) if search_params[:sort].present?
    query = query.search_by_keyword(search_params[:keyword]) if search_params[:keyword].present?
    query = query.search_by_status(search_params[:status]) if search_params[:status].present?
    if search_params[:label_ids].present? && search_params[:label_ids] != ['']
      query = query.match_any_of_label_ids(search_params[:label_ids]).distinct
    end
    query = query.page(search_params[:page])

    @tasks = query

    @labels = Label.all
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
                  flash: { success: I18n.t('messages.create', model_name: I18n.t('activerecord.models.task')) }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task),
                  flash: { success: I18n.t('messages.update', model_name: I18n.t('activerecord.models.task')) }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to tasks_url,
                flash: { success: I18n.t('messages.destroy', model_name: I18n.t('activerecord.models.task')) }
  end

  private

  def set_task
    task = Task.find(params[:id])
    raise ActionController::BadRequest if current_user.id != task.user_id

    @task = task
  end

  def task_params
    params.require(:task).permit(:name, :end_date, :priority, :status, :explanation).merge(user_id: current_user.id)
  end

  def search_params
    params[:sort] = Task.check_approved_sort_params(params[:sort]) if params[:sort].present?
    params.permit(:page, :keyword, :status, :sort, label_ids: [])
  end
end
