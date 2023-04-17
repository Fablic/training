class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy show]
  def index
    @task = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.save
      flash[:notice] = '登録に成功しました。'
      redirect_to tasks_path
    else
      flash[:alret] = '登録に失敗しました。'
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:notice] = '更新に成功しました。'
      redirect_to tasks_path
    else
      flash[:alret] = '更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = '削除に成功しました。'
    redirect_to tasks_path
  end

  def show; end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
