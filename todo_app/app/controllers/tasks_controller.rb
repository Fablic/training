# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[edit update show destroy]

  def index
    @sort_params = request_sort_params
    @search = search_params
    @tasks = current_user.tasks.page(params[:page]).title_search(@search[:title]).status_search(@search[:status_ids]).sort_tasks(@sort_params)
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to root_path, flash: { success: I18n.t('tasks.flash.success.create') }
    else
      flash.now[:danger] = I18n.t('tasks.flash.error.create')
      render :new
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)

      flash[:success] = I18n.t('tasks.flash.success.update')
      redirect_to task_path(@task)
    else
      flash.now[:danger] = I18n.t('tasks.flash.error.update')
      render :edit
    end
  end

  def destroy
    @task.delete

    flash[:success] = I18n.t('tasks.flash.success.destroy')
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status)
  end

  def find_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def request_sort_params
    if check_sort_key && params[:sort_val].present?
      { params[:sort_key]&.to_sym => set_sort_val }
    else
      { created_at: :asc, due_date: :asc }
    end
  end

  def check_sort_key
    %i[due_date created_at].include?(params[:sort_key]&.to_sym)
  end

  def set_sort_val
    params[:sort_val]&.to_sym.eql?(:desc) ? :desc : :asc
  end

  def search_params
    params.fetch(:search_params, {}).permit(:title, status_ids: [])
  end
end
