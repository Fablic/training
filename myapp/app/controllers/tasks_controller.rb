class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'タスクの登録に成功しました。'
    else
      flash.now[:alert] = 'タスクの登録に失敗しました。'
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクの更新に成功しました。'
    else
      flash.now[:alert] = 'タスクの更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, notice: 'タスクの削除に成功しました。'
    end
  end

  def show; end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def record_not_found
    redirect_to root_path, alert: '該当するタスクがありませんでした。'
  end

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
