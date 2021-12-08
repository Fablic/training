class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @tasks = Task.order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)
    content = params[:content]
    status = params[:status]
    @tasks = @tasks.where('name LIKE ?', "%#{content}%") if content.present?
    @tasks = @tasks.where(status: status) if status.present?
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    # 以下2行は次のStepでログインユーザーに変更するため、暫定処置
    user = User.first
    @task.user_id = user.id
    if @task.save
      flash[:success] = 'タスク作成に成功しました！'
      redirect_to @task
    else
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
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
end
