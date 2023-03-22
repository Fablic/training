class TasksController < ApplicationController
  before_action :require_login
  before_action :fetch_task, only: [:show, :edit, :update, :destroy]

  def index
    @task_columns_with_sorting_direction = task_columns_with_sorting_direction

    @tasks = @current_user.tasks.status(params[:status]).name_contain(params[:name]).tag_contain(params[:tag_id])
    @tasks = @tasks.order("#{params[:sort_key]} #{sort_direction}") if params[:sort_key].present?

    # 特定のタグに紐づくタスクに絞り込んだ後、それぞれのタスクに紐づくタグをすべて表示したいので、再度 Task のクエリを実行する
    @tasks = Task.where(id: @tasks.map { |t| t.id }).includes(:tags).page(params[:page])
  end

  def new
    @task = Task.new
  end

  def create
    @task = @current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = I18n.t('flash.task.create.success')
      return redirect_to @task
    end

    flash.now[:danger] = I18n.t('flash.task.create.failure')
    render 'new', status: :unprocessable_entity
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t('flash.task.update.success')
      return redirect_to @task
    end

    flash.now[:danger] = I18n.t('flash.task.update.failure')
    render 'edit', status: :unprocessable_entity
  end

  def destroy
    if @task.destroy
      flash[:success] = I18n.t('flash.task.delete.success')
    else
      flash.now[:danger] = I18n.t('flash.task.delete.failure')
    end
    redirect_to tasks_url
  end

  private

  def fetch_task
    @task = @current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :deadline_at, tag_ids: [])
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

  def reversed_sort_direction
    sort_direction == 'asc' ? 'desc' : 'asc'
  end

  def task_columns_with_sorting_direction
    Task.column_names.map do |column_name|
      next if ['user_id', 'description', 'created_at', 'updated_at'].include?(column_name)

      {
        name: column_name,
        sort_direction: params[:sort_key] == column_name ? reversed_sort_direction : 'asc',
      }
    end.compact
  end
end
