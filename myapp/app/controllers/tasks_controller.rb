# frozen_string_literal: true

class TasksController < ApplicationController # rubocop:todo Style/Documentation
  def index
    @tasks = Task.order(created_at: :asc)
    return unless params[:sort] == 'latest'

    @tasks = Task.order(created_at: :desc)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @labels = Label.order(created_at: :asc)
  end

  def edit
    @task = Task.find(params[:id])
    @labels = Label.order(created_at: :asc)
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = 1 # because user must exist
    @task.user_type = 'Task' # user_type is needed because of NOT NULL
    if @task.save
      flash[:success] = t('task.flashes.success.created')
      redirect_to tasks_path(@task)
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = t('task.flashes.success.updated')
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = t('task.flashes.success.deleted')
    redirect_to tasks_path, status: 303
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, :due_date, :status, :user_id, :assigned_user_id, label_ids: [])
  end
end
