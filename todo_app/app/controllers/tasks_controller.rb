class TasksController < ApplicationController

  before_action :find_task, only: [:edit, :update, :show, :destroy]

  def index
    set_search_params
    @tasks = Task.title_search(@search[:title]).status_search(@search[:status_ids]).sort_tasks(request_sort_params)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = I18n.t('tasks.flash.success.create')
      redirect_to root_path
    else
      render :new
    end
  rescue => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
  end

  def update
    if @task.update(task_params)

      flash[:success] = I18n.t('tasks.flash.success.update')
      redirect_to task_path(@task)
    else
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
    @task = Task.find_by(id: params[:id])
  end

  def request_sort_params
    if check_sort_key && params[:sort_val].present?
      { params[:sort_key]&.to_sym => set_sort_val }
    else
      { created_at: :asc, due_date: :asc }
    end
  end

  def check_sort_key
    %i(due_date created_at).include?(params[:sort_key]&.to_sym)
  end

  def set_sort_val
    params[:sort_val]&.to_sym.eql?(:desc) ? :desc : :asc
  end

  def set_search_params
    @search = {
      title: params.dig(:search_params, :title),
      status_ids: params.dig(:search_params, :status_ids), 
    }.merge(request_sort_params)
  end
end
