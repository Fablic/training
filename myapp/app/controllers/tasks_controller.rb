class TasksController < ApplicationController
  before_action :get_user_by_id, only: [:show, :edit, :update]
  def index
    @tasks = Task.all
  end

  def show
    # @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      # タスク作成を通知
      flash[:success] = "Task created!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    # @task = Task.find(params[:id])
  end

  def update
    # @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "Task updated!"
      redirect_to root_path
    else
      render "edit"
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = "Task deleted!"
    redirect_to root_path
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :priority, :status, :expire_at)
    end

    # 指定されたIDのユーザーを取得
    def get_user_by_id
      @task = Task.find(params[:id])
    end

end
