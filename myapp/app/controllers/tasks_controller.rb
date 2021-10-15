# frozen_string_literal: true

# task management
class TasksController < ApplicationController
  def index
    @tasks = Task.search(params[:search])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(post_params)
    flash[:notice] = if @task.save
                       'The task registration is complete.'
                     else
                       'The task update is error.'
                     end
    redirect_to root_path
  end

  def update
    @task = Task.find(params[:id])
    flash[:notice] = if @task.update(post_params)
                       'The task update is complete.'
                     else
                       'The task update is error.'
                     end
    redirect_to root_path
  end

  def destroy
    @task = Task.find(params[:id])
    flash[:notice] = if @task.destroy
                       'The task delete is complete.'
                     else
                       'The task delete is error.'
                     end
    redirect_to root_path
  end

  private

  def post_params
    params.require(:task).permit(
      :task_name, :description, :status,
      :priority, :label, :start_date, :end_date)
  end
end
