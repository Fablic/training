class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction, :search_params
  before_action :logged_in_user
  before_action :displayed_user
  before_action :set_task, only: %i[show edit update destroy]
  before_action :task_owner?, only: %i[show edit update destroy]

  def index
    @search_params = search_params
    @tasks = Task.search(@displayed_user, @search_params).page(params[:page])
  end

  def new
    @task = Task.new
  end

  def show; end

  def edit; end

  def create
    task = Task.new(task_params)
    form = Form::TaskCollection.new(task)
    @task = form.task
    if form.save(task_params)
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.added') }
    else
      redirect_back fallback_location: new_task_path, flash: { validation_error: @task.errors.full_messages }
    end
  end

  def update
    task = Task.find(params[:id])
    form = Form::TaskCollection.new(task)
    @task = form.task
    if form.update(task_params)
      redirect_to @task, flash: { info: I18n.t('pages.tasks.flash.edited') }
    else
      redirect_back fallback_location: edit_task_path, flash: { validation_error: @task.errors.full_messages }
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.deleted') }
  end

  private

  def task_params
    params.require(:task).permit(:title, :detail, :priority, :status, :due_date, :image, :user_id, :label)
  end

  def search_params
    params.permit(:title, :status, :user_id, :label, :direction, :sort)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def set_task
    task = Task.includes(:labels).find(params[:id])
    form = Form::TaskCollection.new(task)
    @task = form.task
  end

  def displayed_user
    user = User.find_by(id: params[:user_id])
    @displayed_user = adminer? && user.present? ? user : current_user
  end

  def task_owner?
    redirect_to root_path if @task.user_id != @displayed_user.id
  end
end
