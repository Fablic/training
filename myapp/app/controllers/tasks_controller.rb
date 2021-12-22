class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :logged_in_user
  before_action :correct_user, only: %i[destroy edit]

  def index
    content = params[:content]
    status = params[:status]
    labels = params[:label]
    @tasks = current_user.tasks.order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)
    @tasks = @tasks.where('name LIKE ?', "%#{content}%") if content.present?
    @tasks = @tasks.where(status: status) if status.present?
    if labels.present?
      label_ids = labels.values
      task_ids = TaskLabel.where(label_id: label_ids).select(:task_id)
      @tasks = @tasks.where(id: task_ids)
    end
    @labels = Label.all.select('id, name')
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @labels = Label.all.select('id, name')
  end

  def create
    labels = params[:task][:label]
    @task = Task.new(task_params)
    @task.label_ids = labels.values.map(&:to_i) if labels.present?
    @task.user = current_user
    if @task.save
      flash[:success] = 'タスク作成に成功しました！'
      redirect_to @task
    else
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @labels = Label.all.select('id, name')
  end

  def update
    labels = params[:task][:label]
    @task = Task.find(params[:id])
    @task.label_ids = labels.present? ? labels.values.map(&:to_i) : []
    if @task.update(task_params)
      flash[:success] = 'タスク更新に成功しました！'
      redirect_to @task
    else
      render 'edit'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = 'タスク削除成功！'
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :deadline_at, :status)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to root_url if @task.nil?
  end
end
