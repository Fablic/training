# frozen_string_literal: true

class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  before_action :set_task_by_id, only: %i[show edit update destroy]
  def index
    @tasks = Task.all.order(sort_column + ' ' + sort_direction)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'タスクが投稿されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクが投稿されません'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクが編集されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが編集されませんでした'
      render :new
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path
  end

  private

  def set_task_by_id
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :priority, :progress)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end


end
