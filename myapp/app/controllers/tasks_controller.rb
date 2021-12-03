# frozen_string_literal: true

# task management
class TasksController < ApplicationController
  helper_method :sort_direction

  before_action :logged_in_user
  before_action :set_task, only: %i[show edit update destroy]

  def index
#    @tasks = Task.all
    @search_params = user_search_params
    @search_params[:user_id] = current_user.id
    @tasks = Task.search_condition(@search_params)
    @tasks = @tasks.order("#{sort_column} #{sort_direction}")
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(post_params)

    if @task.save
      flash[:notice] = t('tasks.flash.complete_task_registration')
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @task.update(post_params)
      flash[:notice] = t('tasks.flash.complete_task_edit')
      redirect_to root_path
    else
      render :edit
    end
    flash[:notice] = if @task.save
                       t('tasks.flash.complete_task_registration')
                     else
                       t('tasks.flash.error_task_registration')
                     end
    redirect_to root_path
  end

  def update
    @task = Task.find(params[:id])
    flash[:notice] = if @task.update(post_params)
                       t('tasks.flash.complete_task_edit')
                     else
                       t('tasks.flash.error_task_edit')
                     end
    redirect_to root_path
  end

  def destroy
    flash[:notice] = if @task.destroy
                       t('tasks.flash.complete_task_destroy')
                     else
                       t('tasks.flash.error_task_destroy')
                     end
    redirect_to root_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def user_search_params
    params.fetch(:search, {}).permit(:task_name_cont, :status_eq)
  end

  def post_params
    params.require(:task).permit(
      :task_name, :description, :status,
      :priority, :label, :start_date, :end_date,
      :user_id)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) && (params[:direction] == 'asc') ? 'desc' : 'asc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

end
