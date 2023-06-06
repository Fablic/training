class TasksController < ApplicationController
  before_action :require_login
  before_action :ensure_correct_user, only: %i[edit update destroy show]

  def index
    @tasks = @current_user.tasks.includes(:labels).order(created_at: 'DESC').page(params[:page]).per(5)
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit
    @label_list = @task.labels.pluck(:name).join(',')
  end

  def create
    @task = @current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, success: t('messages.create', model_name: t('activerecord.models.task'))
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, success: t('messages.update', model_name: t('activerecord.models.task'))
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, success: t('messages.delete', model_name: t('activerecord.models.task'))
    else
      render :index
    end
  end

  def search
    @tasks = @current_user.tasks.includes(:labels)
      .where_title(params[:title])
      .where_status(params[:status])
      .deadline_order(params[:deadline_order])
      .search_label(params[:label])
      .page(params[:page]).per(5)
    @label_list = Label.all
    @title = params[:title]
    @status = params[:status]
    @deadline_order = params[:deadline_order]
    @label_id = params[:label_id]
    render :index
  end

  private

  def ensure_correct_user
    @task = Task.find(params[:id])
    return if @task.user == @current_user

    redirect_to root_path, danger: t('error.messages.no_authority')
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, label_ids: []).merge(user_id: current_user.id)
  end
end
