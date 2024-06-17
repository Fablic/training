class TasksController < ApplicationController
  before_action :require_login
  before_action :authorize_task, only: [:show, :edit, :update]
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token

  def index
    if params.except(:controller, :action, :page).present?
      sort_by_whitelist = %w[due created_at]
      order_whitelist = %w[desc asc]
      
      sort_by = params[:sort_by]
      order = params[:order].downcase

      sort_by = sort_by_whitelist.include?(sort_by) ? sort_by : 'created_at'
      order = order_whitelist.include?(order) ? order : 'desc'

      query_title = params[:query_title] || ''
      query_status = params[:query_status]
    
      @tasks = find_tasks_by_user.search_with_sort(query_title, query_status, sort_by, order).page(params[:page])
    else
      @tasks = find_tasks_by_user.order(created_at: :desc).page(params[:page])
    end
  end

  def new 
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'New task was created successfully!'
    else
      render :new
    end
  end

  def show
    @task = find_task(params[:id])
  end

  def edit
    @task = find_task(params[:id])
  end

  def update
    @task = find_task(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Edit task successfully!'
    else
      render :edit
    end

  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path, notice: 'Deleted task successfully!'
  end

  private 
  def find_task(id)
    Task.find(id)
  end

  def task_params
    result = params.require(:task).permit(:title, :description, :due, :status, label_ids: [])
    result[:user_id] = session[:user_id]
    result
  end

  def find_tasks_by_user
    User.find(session[:user_id]).tasks
  end

  def authorize_task
    if find_tasks_by_user.find_by(id: params[:id]).nil?
      redirect_to tasks_path, notice: 'No task found!'
    end
  end

  def handle_invalid_authenticity_token
    redirect_to tasks_path, notice: 'Invalid updating request!'
  end
end
