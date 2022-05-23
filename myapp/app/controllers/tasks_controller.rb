class TasksController < ApplicationController
  before_action :current_user
  before_action :require_log_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.all_sort_by(:created_at, :desc).page(params[:page])
  end

  def sort
    if params[:termination_at_latest]
      @tasks = current_user.tasks.all_sort_by(:termination_at, :desc).page(params[:page])
    elsif params[:termination_at_oldest]
      @tasks = current_user.tasks.all_sort_by(:termination_at, :asc).page(params[:page])
    end
    render :index
  end

  def search
    @search_params = input_search_params
    @tasks = current_user.tasks.search(@search_params).page(params[:page])
    render :index
  end

  def show; end

  def new
    @task = Task.new()
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: t('tasks.flash.new')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('tasks.flash.update')
    else
      render :edit
    end
  end

  def destroy
    return unless @task.destroy
    
    redirect_to tasks_path, notice: t('tasks.flash.destroy')
  end

  private

    def task_params
      params.require(:task).permit(:user_id, :title, :description, :termination_at, :priority, :status)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def input_search_params
      params.fetch(:search, {}).permit(:title, :status)
    end
end
