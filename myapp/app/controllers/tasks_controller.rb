class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy show]
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'タスク登録に成功しました。'
    else
      flash.now[:alert] = 'タスクの保存に失敗しました。'
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, flash: { notice: '更新に成功しました。' }
    else
      flash.now[:alert] = '更新を保存できませんでした。'
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: '削除に成功しました。'
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
