class TasksController < ApplicationController
  helper_method :sort_column, :sort_type

  def index
    @search_text = params[:search_text]
    @search_status = params[:search_status]
    @tasks = if params[:search_text].present? || params[:search_status].present?
               search_tasks
             else
               Task.order("#{sort_column} #{sort_type}")
             end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('.flash_success')
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('.flash_success')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: t('.flash_success')
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status)
  end

  def sort_type
    %w[asc desc].include?(params[:type]) ? params[:type] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def search_tasks
    Task.where('(title like ? or description like ?) and status = ?', "%#{params[:search_text]}%",
               "%#{params[:search_text]}%", params[:search_status])
  end
end
