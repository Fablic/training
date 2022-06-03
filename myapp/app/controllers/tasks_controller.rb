class TasksController < ApplicationController
  before_action :logged_in_user, only: %i[index edit new update destroy]
  include TasksHelper
  PER_PAGE = 5

  def index
    @search_text = params[:search_text]
    @search_status = params[:search_status]
    @sort_type = sort_type
    @sort_column = sort_column
    task_list = tasks
    flash[:info] = t('.flash_no_task') if task_list.count.zero?
    @tasks = task_list.page(params[:page]).per(PER_PAGE)
  end

  def new
    @task = Task.new
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, flash: { success: t('.flash_success') }
    else
      render :new
    end
  end

  def edit
    return redirect_to tasks_path unless login_user_task?

    @task = current_user.tasks.find(params[:id])
  end

  def update
    return redirect_to tasks_path unless login_user_task?

    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, flash: { success: t('.flash_success') }
    else
      render :edit
    end
  end

  def destroy
    return redirect_to tasks_path unless login_user_task?

    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_path, flash: { success: t('.flash_success') }
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :content)
  end

  def tasks
    if params[:search_text].present? || params[:search_status].present?
      current_user.tasks.where('(title like ? or description like ?) and status = ?', "%#{params[:search_text]}%",
                               "%#{params[:search_text]}%", params[:search_status]).order("#{sort_column} #{sort_type}")
    else
      current_user.tasks.order("#{sort_column} #{sort_type}")
    end
  end

  def login_user_task?
    current_user.tasks.exists?(id: params[:id])
  end
end
