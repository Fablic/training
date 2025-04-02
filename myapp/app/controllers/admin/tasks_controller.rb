class Admin::TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  PER_PAGE = 10
  
  def index
    if params[:user_id]
        tasks_scope = User.active.find(params[:user_id]).tasks.active
        @q = tasks_scope.ransack(params[:q])
        @q.sorts = 'created_at asc' if @q.sorts.empty?
        @tasks = @q.result.includes(:labels).page(params[:page]).per(PER_PAGE)
    else
        @q = Task.active.ransack(params[:q])
        @q.sorts = 'created_at asc' if @q.sorts.empty?
        @tasks = @q.result.includes(:user, :labels).page(params[:page]).per(PER_PAGE)
    end
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

  def set_task
    @task = Task.active.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :user_id, :priority, :status, :deadline)
  end

  def require_admin
    raise ActionController::RoutingError, "404" unless current_user&.is_admin
  end
end
