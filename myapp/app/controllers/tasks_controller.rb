class TasksController < ApplicationController
  before_action :require_login

  def index
    @tasks = Task.dynamic_search(params || {}).where(user_id: current_user.id)
    case params[:sort_by]
    when 'created_at'
      @tasks = @tasks.order(created_at: params[:sort_order] || :desc)
    when 'deadline'
      @tasks = @tasks.order(deadline: params[:sort_order] || :desc)
    end
  
    # Paginate the results
    @tasks = @tasks.page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
    @labels = @task.labels
  end

  def new
    @task = Task.new
    @labels = Label.all
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:success] = t('task.created_success')
      redirect_to task_path(@task)
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
    @labels = Label.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = t('task.updated_success')
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = t('task.deleted_success')
    redirect_to root_path, status: 303
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :deadline, :status, :user_id, label_ids: [])
  end
  private

  def require_login
    unless current_user
      redirect_to login_path, alert: "Please login"
    end
  end
end
