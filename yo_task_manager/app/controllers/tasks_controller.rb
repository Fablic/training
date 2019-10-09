# frozen_string_literal: true

class TasksController < ApplicationController
  include TaskHelper
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if params[:title] || params[:aasm_state]
      # add search logic here.
      @tasks = Task.all.order(sort_column + ' ' + sort_direction)
    else
      @tasks = Task.all.order(sort_column + ' ' + sort_direction)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = [t('.task_saved')]
      redirect_to tasks_path
    else
      flash[:danger] = ['問題が発生しました。タスクが保存されていません。', @task.errors.full_messages].flatten
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = [t('.task_updated')]
      redirect_to tasks_path
    else
      flash.now[:danger] = ['問題が発生しました。タスクが更新されていません。', @task.errors.full_messages].flatten
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = [t('.task_deleted')]
    else
      flash[:danger] = ['問題が発生しました。タスクが削除されていません。', @task.errors.full_messages].flatten
    end
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :body, :task_limit, :aasm_state)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
