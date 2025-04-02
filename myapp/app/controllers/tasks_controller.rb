class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]
  
  PER_PAGE = 10
  
  def index
    @q = current_user.tasks.active.ransack(params[:q])
    @q.sorts = 'created_at asc' if @q.sorts.empty?
    @tasks = @q.result.includes(:labels).page(params[:page]).per(PER_PAGE)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = I18n.t 'msg_create_success'
      redirect_to @task
    else
      flash.now[:alert] = I18n.t 'msg_create_failure'
      render :new, status: 422
    end
  end

  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t 'msg_update_success'
      redirect_to @task
    else
      flash.now[:alert] = I18n.t 'msg_update_failure'
      render :edit, status: 422
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t 'msg_delete_success'
      redirect_to tasks_url
    else
      flash[:alert] = I18n.t 'msg_delete_failure'
      redirect_to @task
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.active.find(params[:id])
  end

  # Only allow a list of trusted parameters.
  def task_params
    params.require(:task).permit(:name, :description, :user_id, :priority, :status, :deadline, label_ids: [])
  end

  # Prevent action if current_user is not admin and not the owner of the task
  def authorize_user
    unless current_user.is_admin || @task.user == current_user
      flash[:alert] = I18n.t 'msg_unauthorized'
      redirect_to tasks_path
    end
  end
end
