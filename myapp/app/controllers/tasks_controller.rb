class TasksController < ApplicationController
  before_action :require_sign_in!

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.priority_point = @task.get_priority_point
    @task.save
    redirect_to root_path, notice: '新しいタスクを作成しました'
  end

  def index; end

  def list
    @taskList = Task.findByUserId(@current_user.id)
    @tasks = Kaminari.paginate_array(@taskList).page(params[:page]).per(10)
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.priority_point = Task.new(task_params).get_priority_point
    task.update(task_params)
    redirect_to root_path, notice: '#' + params[:id] + 'を更新しました'
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to root_path, notice: '#' + params[:id] + 'を削除しました'
  end

  def search
    @tasks = Task.search(params[:keyword], params[:status], @current_user.id).page(params[:page]).per(10)
    @keyword = params[:keyword]
    @status = params[:status]
    render "list"
  end

  def destroy_api
    task = Task.find(params[:id])
    if task.destroy then
        render json: { status: 'SUCCESS'}
    else
        render json: { status: 'ERROR'}
    end
  end

  def board_api
    render json: Task.boardDataCreate(params[:userId])
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :status, :urgency, :importance, :deadline)
  end
end
