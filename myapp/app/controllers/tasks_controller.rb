class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.priority_point = @task.get_priority_point
      @task.save(validate: false)
      return redirect_to root_path, notice: '新しいタスクを作成しました'
    end

    render :new
  end

  def index; end

  def list
    @tasks = Task.page(params[:page]).per(10)
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.new(task_params)
    if @task.valid?
      task = Task.find(params[:id])
      task.priority_point = @task.get_priority_point
      task.update(task_params)
      return redirect_to root_path, notice: '#' + params[:id] + 'を更新しました'
    end

    render :edit
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to root_path, notice: '#' + params[:id] + 'を削除しました'
  end

  def search
    @tasks = Task.search(params[:keyword], params[:status]).page(params[:page]).per(10)
    @keyword = params[:keyword].present? ? params[:keyword] : ''
    @status = params[:status].present? ? params[:status] : ''
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
    render json: Task.board_bata_create
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :status, :urgency, :importance, :deadline)
  end
end
