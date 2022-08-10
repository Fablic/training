class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.new(task_params)
    @task.save!
    
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。" }
      format.json { render :show, status: :ok, location: @task }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url, notice: "タスク「#{@task.name}」を更新しました。" }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json, @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。" }
      format.json { head :no_content }
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :detail, :status, :priority)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
