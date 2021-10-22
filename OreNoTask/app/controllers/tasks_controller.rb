# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :logged_in_user

  def index
    @tasks = Task.active.user(current_user.id).order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)
  end

  def new
    @task = Task.new
    @submit_label = I18n.t('dictionary.words.save_to_create')
  end

  def edit
    @task = Task.active.user(current_user.id).find_by(id: params[:id])
    @submit_label = I18n.t('dictionary.words.save_to_update')

    redirect_to tasks_path if @task.nil?
  end

  def update
    @task = Task.user(current_user.id).find(params[:id])

    if @task.update(task_params)
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.edited_task')
    else
      render :edit
    end
  end

  def show
    id = params[:id]
    @task = Task.active.user(current_user.id).find_by(id: id)

    redirect_to tasks_path if @task.nil?
  end

  def create
    params = task_params
    params['user_id'] = current_user.id
    @task = Task.new(params)

    if @task.save
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.created_task')
    else
      render :new
    end
  end

  def destroy
    @task = Task.user(current_user.id).find(params[:id])
    flash[:notice] = if @task.update(deleted: 1)
                       I18n.t('dictionary.messages.deleted_task')
                     else
                       I18n.t('dictionary.messages.deleted_task_failed')
                     end

    redirect_to tasks_path
  end

  def search
    @tasks = Task.search(params[:keyword], params[:status], current_user.id, "#{sort_column} #{sort_direction}").page(params[:page]).per(10)
    @keyword = params[:keyword]
    @status = params[:status]
    render :index
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :status, :start_at, :due_date_at)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
