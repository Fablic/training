class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @q = Task.ransack(params[:q])
    @q.sorts = 'created_at asc' if @q.sorts.empty?
    @tasks = @q.result(distinct: true).page(params[:page]).per(10)
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
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters.
  def task_params
    params.require(:task).permit(:name, :description, :user_id, :priority, :status, :deadline)
  end
end
