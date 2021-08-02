class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :current_user
  before_action :set_task, only: %i[show edit update destroy]
  before_action :redirect_top_when_differ_user_task, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = Task.without_deleted
                 .includes_status
                 .includes_priority
                 .includes_user(current_user.id)
                 .search_task_name(params[:keyword])
                 .search_status(params[:statuses])
                 .sort_task("#{sort_column} #{sort_direction}")
                 .page(params[:page])
    @status_list = MasterTaskStatus.all
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    create_params = task_params.merge(status_id: MasterTaskStatus::NOT_STARTED)
    @task = Task.new(create_params)
    if @task.save
      current_user.add_task(@task)
      redirect_to @task, notice: 'タスクを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 論理削除
  def destroy
    now = Time.current.strftime('%Y-%m-%d %H:%M:%S')
    if @task.update(deleted_at: now)
      redirect_to tasks_url, notice: 'タスクを削除しました。'
    else
      redirect_to tasks_url, notice: 'タスクの削除に失敗しました。'
    end
  end

  private

  # 共通処理
  def set_task
    @task = Task.find(params[:id])
  end

  def redirect_top_when_differ_user_task
    redirect_to root_path unless current_user.own_task?(@task)
  end

  def task_params
    params.require(:task).permit(:task_name, :status_id, :priority_id, :label, :limit_date, :detail)
  end

  def sort_direction
    params[:direction].in?(%w[asc desc]) ? params[:direction] : 'desc'
  end

  def sort_column
    params[:sort].in?(Task.column_names) ? params[:sort] : 'tasks.created_at'
  end
end
