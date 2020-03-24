class TasksController < ApplicationController
  before_action :task, only: %i[destroy show edit update]
  before_action -> { redirect_to sign_in_path }, unless: -> { current_user.present? }

  ORDER = %w[asc desc].freeze
  ROWS_PER_PAGE = 5

  def index
    @search_params = task_search_params
    @tasks = Task.preload(:user)
      .where('user_id = ?', current_user.id)
      .page(params[:page])
      .per(ROWS_PER_PAGE)
      .search(@search_params)
      .order(format('%s %s', sort_position, sort_order))
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params).tap { |obj| obj.user = current_user }
    if @task.save
      flash[:success] = t('flash.create.success')
      redirect_to @task
    else
      flash.now[:danger] = t('flash.create.danger')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = t('flash.update.success')
      redirect_to @task
    else
      flash.now[:danger] = t('flash.update.danger')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('flash.remove.success')
    else
      flash[:danger] = t('flash.remove.danger')
    end
    redirect_to tasks_url
  end

  def task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :summary,
      :description,
      :priority,
      :status,
      :due
    )
  end

  def task_search_params
    params.fetch(:search, {}).permit(:summary, :status)
  end

  def sort_position
    column = params[:position] if params[:position].present?
    Task.column_names.include?(column) ? column : 'id'
  end

  def sort_order
    order = params[:order] if params[:order].present?
    ORDER.include?(order) ? order : 'desc'
  end
end
